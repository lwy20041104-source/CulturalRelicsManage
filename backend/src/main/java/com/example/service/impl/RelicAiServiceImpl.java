package com.example.service.impl;

import com.example.dto.AiRelicItemVO;
import com.example.dto.AiRelicQueryResponse;
import com.example.entity.CulturalRelic;
import com.example.service.CulturalRelicService;
import com.example.service.RelicAiService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriUtils;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

@Service
public class RelicAiServiceImpl implements RelicAiService {

    private static final Logger log = LoggerFactory.getLogger(RelicAiServiceImpl.class);

    private static final int MAX_RESULTS = 5;
    private static final int MAX_WEB_RESULTS = 1;
    private static final int MAX_RELEVANCE_SCORE = 180;
    private static final String[] MUSEUM_DOMAIN_KEYWORDS = {
            "museum", "muses", "dpm.org.cn", "chnmuseum.cn", "shanximuseum.com", "shanghaimuseum.net",
            "hnmuseum.com", "hnmuseum.com.cn", "gdmuseum.com", "zhejiangmuseum.com", "sxhm.com",
            "bmy.com.cn", "capitalmuseum.org.cn", "njmuseum.com", "hbww.org", "sxmuseum.com",
            "hnmuseum.net", "hubeimuseum.com", "sxww.com.cn", "szmuseum.com", "gzmuseum.com",
            "bjartmuseum.org.cn", "ncha.gov.cn", "wangfujingmuseum.com", "dunhuangmuseum.com",
            "henanmuseum.net", "sichuanmuseum.com", "lnmuseum.com.cn", "zgmuseum.cn"
    };
    private static final String[] ENCYCLOPEDIA_DOMAIN_KEYWORDS = {
            "baike.baidu.com", "bkso.baidu.com", "baike.com", "hudong.com"
    };

    private final CulturalRelicService culturalRelicService;

    public RelicAiServiceImpl(CulturalRelicService culturalRelicService) {
        this.culturalRelicService = culturalRelicService;
    }

    @Override
    public AiRelicQueryResponse queryRelics(String question, Boolean matchAll) {
        String keyword = question == null ? "" : question.trim();
        if (keyword.isEmpty()) {
            throw new IllegalArgumentException("请输入想查询的文物问题或关键词");
        }

        List<String> keywords = splitKeywords(keyword);
        boolean requireAllKeywords = Boolean.TRUE.equals(matchAll);
        List<RelicMatchScore> matched = new ArrayList<>();
        for (CulturalRelic relic : culturalRelicService.list()) {
            RelicMatchScore score = calculateScore(relic, keyword, keywords);
            if (score.getMatchedKeywordCount() == 0) {
                continue;
            }
            if (requireAllKeywords && score.getMatchedKeywordCount() < keywords.size()) {
                continue;
            }
            matched.add(score);
        }

        matched.sort(Comparator
                .comparingInt(RelicMatchScore::getMatchedKeywordCount).reversed()
                .thenComparingInt(RelicMatchScore::getScore).reversed()
                .thenComparing(match -> match.getRelic().getId(), Comparator.nullsLast(Long::compareTo)));

        List<AiRelicItemVO> items = new ArrayList<>();
        for (RelicMatchScore match : matched) {
            CulturalRelic relic = match.getRelic();
            AiRelicItemVO item = new AiRelicItemVO();
            item.setId(relic.getId());
            item.setRelicName(relic.getRelicName());
            item.setImagePath(relic.getImagePath());
            item.setEra(relic.getEra());
            item.setMaterial(relic.getMaterial());
            item.setStatus(relic.getStatus());
            item.setCategoryName(relic.getCategoryName());
            item.setDimensions(relic.getDimensions());
            item.setWeight(relic.getWeight());
            item.setDescription(relic.getDescription());
            item.setIntroduction(buildIntroduction(relic));
            item.setRelevancePercent(toRelevancePercent(match.getScore()));
            item.setMatchTags(match.getMatchTags());
            items.add(item);
            if (items.size() >= MAX_RESULTS) {
                break;
            }
        }

        AiRelicQueryResponse response = new AiRelicQueryResponse();
        response.setRelics(items);
        response.setTotal(items.size());
        response.setMuseumHit(!items.isEmpty());
        response.setMuseumMessage(items.isEmpty() ? "本博物馆里无此文物" : "已为你检索到本馆相关文物");
        response.setTopReason(buildTopReason(keyword, items));
        if (items.isEmpty()) {
            List<AiRelicItemVO> webRelics = searchExternalRelics(keyword);
            response.setRelics(webRelics);
            response.setTotal(webRelics.size());
            response.setAnswer(buildExternalAnswer(keyword, webRelics));
            response.setWebResults(new ArrayList<>());
        } else {
            response.setAnswer(buildAnswer(keyword, items));
            response.setWebResults(new ArrayList<>());
        }
        return response;
    }

    private int toRelevancePercent(int score) {
        int percent = (int) Math.round(score * 100.0 / MAX_RELEVANCE_SCORE);
        if (percent < 1) {
            return 1;
        }
        return Math.min(percent, 100);
    }

    private String buildTopReason(String keyword, List<AiRelicItemVO> items) {
        if (items.isEmpty()) {
            return "";
        }
        AiRelicItemVO top = items.get(0);
        if (top.getMatchTags() == null || top.getMatchTags().isEmpty()) {
            return "当前排在第 1 位的文物与“" + keyword + "”整体相关度最高。";
        }
        int end = Math.min(3, top.getMatchTags().size());
        List<String> reasons = top.getMatchTags().subList(0, end);
        return "TOP 1 文物“" + top.getRelicName() + "”当前排在最前，是因为它的相关度最高（" + top.getRelevancePercent() + "%），并且优先命中了：" + String.join("、", reasons) + "。";
    }

    private RelicMatchScore calculateScore(CulturalRelic relic, String fullKeyword, List<String> keywords) {
        int totalScore = 0;
        Set<String> matchedKeywords = new LinkedHashSet<>();
        List<String> matchTags = new ArrayList<>();

        if (contains(relic.getRelicName(), fullKeyword)) {
            totalScore += 80;
            addTag(matchTags, "名称整句命中");
        }
        if (contains(relic.getRelicCode(), fullKeyword)) {
            totalScore += 70;
            addTag(matchTags, "编号整句命中");
        }
        if (contains(relic.getDescription(), fullKeyword) || contains(relic.getOrigin(), fullKeyword)) {
            totalScore += 30;
            addTag(matchTags, "描述/来源整句命中");
        }

        for (String keyword : keywords) {
            KeywordScore score = scoreKeyword(relic, keyword);
            if (score.getScore() > 0) {
                matchedKeywords.add(keyword);
                totalScore += score.getScore();
                matchTags.addAll(score.getTags());
            }
        }

        return new RelicMatchScore(relic, totalScore, matchedKeywords.size(), deduplicateTags(matchTags));
    }

    private KeywordScore scoreKeyword(CulturalRelic relic, String keyword) {
        int score = 0;
        List<String> tags = new ArrayList<>();
        List<String> terms = expandKeyword(keyword);

        if (matchesAny(relic.getRelicName(), terms)) {
            score += 40;
            addTag(tags, "名称命中：" + keyword);
        }
        if (matchesAny(relic.getRelicCode(), terms)) {
            score += 35;
            addTag(tags, "编号命中：" + keyword);
        }
        if (matchesAny(relic.getEra(), terms)) {
            score += 24;
            addTag(tags, "年代命中：" + keyword);
        }
        if (matchesAny(relic.getMaterial(), terms)) {
            score += 24;
            addTag(tags, "材质命中：" + keyword);
        }
        if (matchesAny(relic.getStatus(), terms)) {
            score += 24;
            addTag(tags, "状态命中：" + keyword);
        }
        if (matchesAny(relic.getCategoryName(), terms)) {
            score += 20;
            addTag(tags, "分类命中：" + keyword);
        }
        if (matchesAny(relic.getDescription(), terms)) {
            score += 12;
            addTag(tags, "描述命中：" + keyword);
        }
        if (matchesAny(relic.getOrigin(), terms)) {
            score += 10;
            addTag(tags, "来源命中：" + keyword);
        }

        return new KeywordScore(score, tags);
    }

    private List<String> splitKeywords(String keyword) {
        String[] parts = keyword.toLowerCase().trim().split("\\s+");
        List<String> result = new ArrayList<>();
        for (String part : parts) {
            if (!part.isEmpty()) {
                result.add(part);
            }
        }
        return result;
    }

    private List<String> expandKeyword(String keyword) {
        Set<String> terms = new LinkedHashSet<>();
        terms.add(keyword);

        if ("铜器".equals(keyword)) {
            terms.add("青铜器");
            terms.add("铜");
        }
        if ("青铜器".equals(keyword)) {
            terms.add("铜器");
            terms.add("铜");
        }
        if ("陶器".equals(keyword) || "瓷器".equals(keyword)) {
            terms.add("陶瓷");
        }
        if ("陶瓷".equals(keyword)) {
            terms.add("陶器");
            terms.add("瓷器");
        }
        if ("在馆".equals(keyword) || "馆藏".equals(keyword)) {
            terms.add("在库");
        }
        if ("修缮".equals(keyword)) {
            terms.add("修复中");
        }
        if ("借出".equals(keyword) || "借出中".equals(keyword)) {
            terms.add("借展中");
        }

        addAliasTerms(terms, keyword);

        for (String term : new ArrayList<>(terms)) {
            if (term.length() > 1 && term.endsWith("器")) {
                terms.add(term.substring(0, term.length() - 1));
            }
        }
        return new ArrayList<>(terms);
    }

    private void addAliasTerms(Set<String> terms, String keyword) {
        if ("司母戊鼎".equals(keyword) || "后母戊鼎".equals(keyword)) {
            terms.add("司母戊鼎");
            terms.add("后母戊鼎");
            terms.add("后母戊");
        }
        if ("四羊方尊".equals(keyword) || "四羊青铜方尊".equals(keyword)) {
            terms.add("四羊方尊");
            terms.add("四羊青铜方尊");
        }
        if ("越王勾践剑".equals(keyword) || "勾践剑".equals(keyword)) {
            terms.add("越王勾践剑");
            terms.add("勾践剑");
        }
        if ("曾侯乙编钟".equals(keyword) || "编钟".equals(keyword)) {
            terms.add("曾侯乙编钟");
            terms.add("编钟");
        }
    }

    private boolean matchesAny(String source, List<String> terms) {
        if (source == null || terms == null || terms.isEmpty()) {
            return false;
        }
        String text = source.toLowerCase();
        for (String term : terms) {
            if (term != null && !term.isEmpty() && text.contains(term)) {
                return true;
            }
        }
        return false;
    }

    private List<String> deduplicateTags(List<String> tags) {
        return new ArrayList<>(new LinkedHashSet<>(tags));
    }

    private void addTag(List<String> tags, String tag) {
        if (!tags.contains(tag)) {
            tags.add(tag);
        }
    }

    private boolean contains(String source, String keyword) {
        return source != null && keyword != null && !keyword.isEmpty() && source.toLowerCase().contains(keyword.toLowerCase());
    }

    private String buildIntroduction(CulturalRelic relic) {
        StringBuilder builder = new StringBuilder();
        builder.append(relic.getRelicName() == null ? "该文物" : relic.getRelicName());
        if (hasText(relic.getEra())) {
            builder.append("，年代为").append(relic.getEra());
        }
        if (hasText(relic.getMaterial())) {
            builder.append("，材质为").append(relic.getMaterial());
        }
        if (hasText(relic.getCategoryName())) {
            builder.append("，分类属于").append(relic.getCategoryName());
        }
        if (hasText(relic.getDimensions())) {
            builder.append("，尺寸为").append(relic.getDimensions());
        }
        if (relic.getWeight() != null) {
            builder.append("，重量约 ").append(String.format("%.2f", relic.getWeight())).append("kg");
        }
        if (hasText(relic.getStatus())) {
            builder.append("，当前状态为").append(relic.getStatus());
        }
        if (hasText(relic.getOrigin())) {
            builder.append("，来源/出土地为").append(relic.getOrigin());
        }
        if (hasText(relic.getDescription())) {
            builder.append("。相关介绍：").append(relic.getDescription());
        } else {
            builder.append("。系统中暂未录入更详细的文字介绍。");
        }
        return builder.toString();
    }

    private String buildAnswer(String keyword, List<AiRelicItemVO> items) {
        if (items.isEmpty()) {
            return "本博物馆里无此文物。";
        }
        if (items.size() == 1) {
            return "已为你找到 1 件与“" + keyword + "”相关的馆藏文物，并补充展示了尺寸和重量信息。";
        }
        return "已为你找到 " + items.size() + " 件与“" + keyword + "”相关的馆藏文物，并补充展示了尺寸和重量信息。";
    }

    private String buildExternalAnswer(String keyword, List<AiRelicItemVO> items) {
        if (items.isEmpty()) {
            return "本博物馆里无此文物，且暂时未检索到合适的外部资料。";
        }
        if (items.size() == 1 && "百科".equals(items.get(0).getSourceType()) && "百度百科".equals(items.get(0).getSourceName())) {
            return hasText(items.get(0).getImagePath())
                    ? "本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。"
                    : "本博物馆里无此文物，已优先为你提供百度百科词条入口。";
        }
        return "本博物馆里无此文物，已为你从全网检索到最符合要求的相关文物资料。";
    }

    private List<AiRelicItemVO> searchExternalRelics(String keyword) {
        List<AiRelicItemVO> results = new ArrayList<>();
        try {
            String rssQuery = buildExternalSearchQuery(keyword);
            String encoded = UriUtils.encode(rssQuery, StandardCharsets.UTF_8);
            String rssUrl = "https://cn.bing.com/search?format=rss&q=" + encoded;
            HttpURLConnection connection = (HttpURLConnection) new URL(rssUrl).openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");
            connection.setRequestProperty("Accept", "application/rss+xml, application/xml, text/xml, */*");

            try (InputStream inputStream = connection.getInputStream()) {
                byte[] bytes = readAllBytes(inputStream);
                Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new ByteArrayInputStream(bytes));
                NodeList items = document.getElementsByTagName("item");
                List<ExternalCandidate> candidates = new ArrayList<>();
                for (int i = 0; i < items.getLength(); i++) {
                    Element element = (Element) items.item(i);
                    String title = getTagText(element, "title");
                    String link = getTagText(element, "link");
                    String description = cleanHtml(getTagText(element, "description"));
                    if (!hasText(title) || !hasText(link)) {
                        continue;
                    }
                    if (!isTitleConsistent(title, keyword)) {
                        logIgnoredExternalLink(link, keyword, "标题与关键词不一致");
                        continue;
                    }
                    String pageHtml = fetchPageHtml(link);
                    String mergedText = (title + " " + description + " " + cleanHtml(pageHtml)).trim();
                    candidates.add(new ExternalCandidate(title, link, description, pageHtml, scoreExternalCandidate(link, mergedText, keyword)));
                }

                candidates.removeIf(candidate -> candidate.getScore() < 0);
                candidates.sort(Comparator.comparingInt(ExternalCandidate::getScore).reversed());
                for (ExternalCandidate candidate : candidates) {
                    AiRelicItemVO item = buildExternalRelic(candidate, keyword);
                    if (item != null) {
                        results.add(item);
                        break;
                    }
                }
                if (results.isEmpty()) {
                    results.add(buildBaikeFallback(keyword));
                }
            }
        } catch (Exception e) {
            log.warn("AI外网检索失败：keyword={}, message={}", keyword, e.getMessage(), e);
            results.add(buildBaikeFallback(keyword));
        }
        return results;
    }

    private String buildExternalSearchQuery(String keyword) {
        String primary = getPrimaryAlias(keyword);
        if (!primary.equals(keyword)) {
            return primary + " " + keyword + " 百度百科 博物馆 文物";
        }
        return keyword + " 百度百科 博物馆 文物";
    }

    private String getPrimaryAlias(String keyword) {
        if (!hasText(keyword)) {
            return "";
        }
        if (keyword.contains("司母戊鼎") || keyword.contains("后母戊鼎")) {
            return "后母戊鼎";
        }
        if (keyword.contains("四羊方尊") || keyword.contains("四羊青铜方尊")) {
            return "四羊方尊";
        }
        if (keyword.contains("勾践剑") || keyword.contains("越王勾践剑")) {
            return "越王勾践剑";
        }
        if (keyword.contains("编钟") || keyword.contains("曾侯乙编钟")) {
            return "曾侯乙编钟";
        }
        return keyword;
    }

    private AiRelicItemVO buildBaikeFallback(String keyword) {
        String primaryAlias = getPrimaryAlias(keyword);
        String baikeUrl = "https://baike.baidu.com/item/" + UriUtils.encode(primaryAlias, StandardCharsets.UTF_8);
        String baikeHtml = fetchPageHtml(baikeUrl);
        String baikeText = cleanHtml(baikeHtml);
        String baikeSummary = extractBaikeSummary(baikeHtml);
        String imageUrl = extractImageUrl(baikeHtml, baikeUrl);
        log.info("AI百度百科兜底抓取：keyword={}, alias={}, htmlLength={}, summaryFound={}, imageFound={}, url={}",
                keyword,
                primaryAlias,
                baikeHtml.length(),
                hasText(baikeSummary),
                hasText(imageUrl),
                baikeUrl);

        AiRelicItemVO item = new AiRelicItemVO();
        item.setId(-1L);
        item.setRelicName(primaryAlias);
        item.setImagePath(imageUrl);
        item.setEra(extractEra(baikeText));
        item.setMaterial(extractMaterial(baikeText));
        item.setStatus("馆外资料");
        item.setCategoryName(extractCategory(baikeText));
        item.setDimensions(extractDimensions(baikeText));
        item.setWeight(extractWeight(baikeText));
        item.setDescription(hasText(baikeSummary) ? summarizeText(baikeSummary) : "未命中馆藏结果，已为你提供百度百科词条直达入口。");
        item.setIntroduction(hasText(baikeSummary)
                ? summarizeText(baikeSummary)
                : "当前未从外网抓取到合适的百科或博物馆官网详情，建议点击来源链接直达百度百科词条页查看。" + (primaryAlias.equals(keyword) ? "" : " 当前已自动按常见异名跳转为“" + primaryAlias + "”。"));
        item.setMatchTags(new ArrayList<>());
        item.setExternal(true);
        item.setSourceName("百度百科");
        item.setSourceType("百科");
        item.setSourceUrl(baikeUrl);
        return item;
    }

    private AiRelicItemVO buildExternalRelic(ExternalCandidate candidate, String keyword) {
        String pageText = cleanHtml(candidate.getPageHtml());
        String mergedText = (candidate.getTitle() + " " + candidate.getDescription() + " " + pageText).trim();
        AiRelicItemVO item = new AiRelicItemVO();
        item.setId(-1L);
        item.setRelicName(cleanTitle(candidate.getTitle(), keyword));
        item.setImagePath(extractImageUrl(candidate.getPageHtml(), candidate.getLink()));
        item.setEra(extractEra(mergedText));
        item.setMaterial(extractMaterial(mergedText));
        item.setStatus("馆外资料");
        item.setCategoryName(extractCategory(mergedText));
        item.setDimensions(extractDimensions(mergedText));
        item.setWeight(extractWeight(mergedText));
        item.setDescription(hasText(candidate.getDescription()) ? candidate.getDescription() : summarizeText(pageText));
        item.setIntroduction(hasText(pageText) ? summarizeText(pageText) : "已从全网检索到相关资料，可点击来源链接查看详情。");
        item.setMatchTags(new ArrayList<>());
        item.setExternal(true);
        item.setSourceName(resolveSourceName(candidate.getLink()));
        item.setSourceType(resolveSourceType(candidate.getLink()));
        item.setSourceUrl(candidate.getLink());
        return item;
    }

    private String fetchPageHtml(String link) {
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(link).openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");
            try (InputStream inputStream = connection.getInputStream()) {
                return new String(readAllBytes(inputStream), StandardCharsets.UTF_8);
            }
        } catch (Exception e) {
            return "";
        }
    }

    private int scoreExternalCandidate(String link, String text, String keyword) {
        String sourceType = resolveSourceType(link);
        if ("公开网页".equals(sourceType)) {
            logIgnoredExternalLink(link, keyword, "来源不在白名单");
            return -1;
        }
        int score = 0;
        String lowerText = text == null ? "" : text.toLowerCase();
        if ("百科".equals(sourceType)) score += 90;
        if ("博物馆官网".equals(sourceType)) score += 80;
        if (containsAlias(lowerText, keyword)) score += 50;
        if (lowerText.contains("文物")) score += 20;
        if (lowerText.contains("年代")) score += 10;
        if (lowerText.contains("材质")) score += 10;
        if (lowerText.contains("尺寸")) score += 10;
        if (lowerText.contains("重量")) score += 10;
        return score;
    }

    private boolean isTitleConsistent(String title, String keyword) {
        if (!hasText(title) || !hasText(keyword)) {
            return false;
        }
        return containsAlias(title.toLowerCase(), keyword);
    }

    private boolean containsAlias(String text, String keyword) {
        if (!hasText(text) || !hasText(keyword)) {
            return false;
        }
        for (String alias : expandKeyword(keyword)) {
            if (hasText(alias) && text.contains(alias.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    private String resolveSourceName(String link) {
        String sourceType = resolveSourceType(link);
        if ("百科".equals(sourceType)) return "百度百科";
        if ("博物馆官网".equals(sourceType)) return "博物馆官网";
        return "全网来源";
    }

    private String resolveSourceType(String link) {
        if (!hasText(link)) return "公开网页";
        String lower = link.toLowerCase();
        if (isEncyclopediaLink(lower)) return "百科";
        if (isMuseumOfficialLink(lower)) return "博物馆官网";
        return "公开网页";
    }

    private boolean isEncyclopediaLink(String lowerLink) {
        if (!hasText(lowerLink)) {
            return false;
        }
        return Stream.of(ENCYCLOPEDIA_DOMAIN_KEYWORDS).anyMatch(lowerLink::contains);
    }

    private boolean isMuseumOfficialLink(String lowerLink) {
        if (!hasText(lowerLink)) {
            return false;
        }
        if (lowerLink.contains("博物馆")) {
            return true;
        }
        return Stream.of(MUSEUM_DOMAIN_KEYWORDS).anyMatch(lowerLink::contains);
    }

    private void logIgnoredExternalLink(String link, String keyword) {
        logIgnoredExternalLink(link, keyword, "已过滤");
    }

    private void logIgnoredExternalLink(String link, String keyword, String reason) {
        String host = extractHost(link);
        if (!hasText(host)) {
            log.info("AI外网检索过滤候选链接：keyword={}, reason={}, link={}", keyword, reason, link);
            return;
        }
        log.info("AI外网检索过滤候选域名：keyword={}, reason={}, host={}, link={}", keyword, reason, host, link);
    }

    private String extractHost(String link) {
        if (!hasText(link)) {
            return "";
        }
        try {
            return new URL(link).getHost();
        } catch (Exception e) {
            return "";
        }
    }

    private String cleanTitle(String title, String keyword) {
        if (!hasText(title)) return keyword;
        return title.replaceAll("[_\\-|].*$", "").trim();
    }

    private String extractBaikeSummary(String html) {
        if (!hasText(html)) {
            return "";
        }
        String cleaned = html.replaceAll("\\r", " ").replaceAll("\\n", " ");
        Matcher matcher = Pattern.compile("<meta[^>]+name=[\"']description[\"'][^>]+content=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE).matcher(cleaned);
        if (matcher.find()) {
            return cleanHtml(matcher.group(1));
        }
        matcher = Pattern.compile("<div[^>]+class=[\"'][^\"']*(lemma-summary|J-summary)[^\"']*[\"'][^>]*>([\\s\\S]*?)</div>", Pattern.CASE_INSENSITIVE).matcher(cleaned);
        if (matcher.find()) {
            return cleanHtml(matcher.group(2));
        }
        return "";
    }

    private String summarizeText(String text) {
        if (!hasText(text)) {
            return "暂无介绍";
        }
        String normalized = text.replaceAll("\\s+", " ").trim();
        return normalized.length() > 180 ? normalized.substring(0, 180) + "..." : normalized;
    }

    private String extractEra(String text) {
        return extractFirst(text, "(新石器时代|旧石器时代|商代|周代|春秋|战国|秦代|汉代|魏晋|南北朝|隋代|唐代|宋代|元代|明代|清代|民国|[东西南北]汉|[东西南北]魏|[东西南北]周)", "未录入");
    }

    private String extractMaterial(String text) {
        return extractFirst(text, "(青铜|铜|金|银|铁|玉|陶|瓷|木|石|漆器|丝织|骨|竹)", "未录入");
    }

    private String extractCategory(String text) {
        return extractFirst(text, "(鼎|簋|尊|壶|镜|瓶|罐|俑|佛像|碑|剑|刀|瓷器|陶器|青铜器|玉器)", "全网检索");
    }

    private String extractDimensions(String text) {
        return extractFirst(text, "((高|长|宽|口径|腹径|通高)[^。；,，]{0,20}(厘米|cm|毫米|mm)([^。；,，]{0,20}(×|x|X)[^。；,，]{0,20})?)", "未录入");
    }

    private Double extractWeight(String text) {
        String value = extractFirst(text, "([0-9]+(?:\\.[0-9]+)?)\\s*(kg|千克|公斤|g|克)", "");
        if (!hasText(value)) {
            return null;
        }
        Matcher matcher = Pattern.compile("([0-9]+(?:\\.[0-9]+)?)\\s*(kg|千克|公斤|g|克)").matcher(value);
        if (!matcher.find()) {
            return null;
        }
        double number = Double.parseDouble(matcher.group(1));
        String unit = matcher.group(2);
        if ("g".equalsIgnoreCase(unit) || "克".equals(unit)) {
            return number / 1000;
        }
        return number;
    }

    private String extractImageUrl(String html, String pageUrl) {
        if (!hasText(html)) {
            log.debug("HTML为空，无法提取图片");
            return "";
        }
        
        // 1. 尝试提取 og:image (Open Graph 标准，优先级最高)
        Matcher matcher = Pattern.compile("<meta[^>]+property=[\"']og:image[\"'][^>]+content=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE).matcher(html);
        if (matcher.find()) {
            String url = normalizeUrl(matcher.group(1), pageUrl);
            log.info("提取到 og:image 图片：{}", url);
            return url;
        }
        
        // 2. 尝试提取 meta name="image"
        matcher = Pattern.compile("<meta[^>]+name=[\"']image[\"'][^>]+content=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE).matcher(html);
        if (matcher.find()) {
            String url = normalizeUrl(matcher.group(1), pageUrl);
            log.info("提取到 meta image 图片：{}", url);
            return url;
        }
        
        // 3. 尝试提取百度百科特有的图片（lemmaWgt-lemmaTitle-image）
        matcher = Pattern.compile("<img[^>]+class=[\"'][^\"']*lemmaWgt-lemmaTitle-image[^\"']*[\"'][^>]+src=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE).matcher(html);
        if (matcher.find()) {
            String url = normalizeUrl(matcher.group(1), pageUrl);
            log.info("提取到百科标题图片：{}", url);
            return url;
        }
        
        // 4. 尝试提取百度百科的主图（summary-pic）
        matcher = Pattern.compile("<img[^>]+class=[\"'][^\"']*summary-pic[^\"']*[\"'][^>]+src=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE).matcher(html);
        if (matcher.find()) {
            String url = normalizeUrl(matcher.group(1), pageUrl);
            log.info("提取到百科摘要图片：{}", url);
            return url;
        }
        
        // 5. 尝试提取 JSON-LD 中的图片
        matcher = Pattern.compile("\"image\"\\s*:\\s*\"(https?:\\/\\/[^\"]+)\"", Pattern.CASE_INSENSITIVE).matcher(html);
        if (matcher.find()) {
            String url = normalizeUrl(matcher.group(1).replace("\\/", "/"), pageUrl);
            log.info("提取到 JSON-LD 图片：{}", url);
            return url;
        }
        
        // 6. 尝试提取百度百科的 data-src 属性（懒加载图片）
        matcher = Pattern.compile("<img[^>]+data-src=[\"']([^\"']+)[\"']", Pattern.CASE_INSENSITIVE).matcher(html);
        if (matcher.find()) {
            String url = normalizeUrl(matcher.group(1), pageUrl);
            if (url.contains("http") && !url.contains("data:image") && isValidImageUrl(url)) {
                log.info("提取到 data-src 图片：{}", url);
                return url;
            }
        }
        
        // 7. 尝试提取所有 img 标签，过滤掉小图标和无效图片
        matcher = Pattern.compile("<img[^>]+src=[\"']([^\"']+)[\"'][^>]*>", Pattern.CASE_INSENSITIVE).matcher(html);
        List<String> candidateImages = new ArrayList<>();
        while (matcher.find()) {
            String url = normalizeUrl(matcher.group(1), pageUrl);
            if (url.contains("http") && !url.contains("data:image") && isValidImageUrl(url)) {
                candidateImages.add(url);
            }
        }
        
        // 优先选择百度百科的图片
        for (String url : candidateImages) {
            if (url.contains("bkimg.cdn.bcebos.com") || url.contains("baike.baidu.com")) {
                log.info("提取到百科 CDN 图片：{}", url);
                return url;
            }
        }
        
        // 选择第一个有效图片
        if (!candidateImages.isEmpty()) {
            String url = candidateImages.get(0);
            log.info("提取到第一个有效图片：{}", url);
            return url;
        }
        
        log.warn("未能从 HTML 中提取到有效图片，pageUrl={}", pageUrl);
        return "";
    }
    
    /**
     * 验证图片 URL 是否有效
     */
    private boolean isValidImageUrl(String url) {
        if (!hasText(url)) {
            return false;
        }
        String lower = url.toLowerCase();
        // 排除常见的小图标和无效图片
        if (lower.contains("logo") || lower.contains("icon") || lower.contains("avatar") 
            || lower.contains("blank") || lower.contains("placeholder")
            || lower.contains("1x1") || lower.contains("spacer")) {
            return false;
        }
        // 只接受常见的图片格式
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") 
            || lower.endsWith(".gif") || lower.endsWith(".webp")
            || lower.contains(".jpg?") || lower.contains(".jpeg?") || lower.contains(".png?")
            || lower.contains(".gif?") || lower.contains(".webp?");
    }

    private String normalizeUrl(String rawUrl, String pageUrl) {
        if (!hasText(rawUrl)) {
            return "";
        }
        if (rawUrl.startsWith("//")) {
            return "https:" + rawUrl;
        }
        if (rawUrl.startsWith("http://") || rawUrl.startsWith("https://")) {
            return rawUrl;
        }
        try {
            return new URL(new URL(pageUrl), rawUrl).toString();
        } catch (Exception e) {
            return rawUrl;
        }
    }

    private String extractFirst(String text, String regex, String defaultValue) {
        if (!hasText(text)) {
            return defaultValue;
        }
        Matcher matcher = Pattern.compile(regex, Pattern.CASE_INSENSITIVE).matcher(text);
        if (matcher.find()) {
            return matcher.group(1).trim();
        }
        return defaultValue;
    }

    private byte[] readAllBytes(InputStream inputStream) throws Exception {
        byte[] buffer = new byte[4096];
        int len;
        java.io.ByteArrayOutputStream outputStream = new java.io.ByteArrayOutputStream();
        while ((len = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, len);
        }
        return outputStream.toByteArray();
    }

    private String getTagText(Element element, String tagName) {
        NodeList nodeList = element.getElementsByTagName(tagName);
        if (nodeList.getLength() == 0 || nodeList.item(0) == null) {
            return "";
        }
        return nodeList.item(0).getTextContent();
    }

    private String cleanHtml(String text) {
        if (!hasText(text)) {
            return "";
        }
        return text.replaceAll("<script[\\s\\S]*?</script>", " ")
                .replaceAll("<style[\\s\\S]*?</style>", " ")
                .replaceAll("<[^>]+>", " ")
                .replaceAll("&nbsp;", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private static class ExternalCandidate {
        private final String title;
        private final String link;
        private final String description;
        private final String pageHtml;
        private final int score;

        private ExternalCandidate(String title, String link, String description, String pageHtml, int score) {
            this.title = title;
            this.link = link;
            this.description = description;
            this.pageHtml = pageHtml;
            this.score = score;
        }

        public String getTitle() {
            return title;
        }

        public String getLink() {
            return link;
        }

        public String getDescription() {
            return description;
        }

        public String getPageHtml() {
            return pageHtml;
        }

        public int getScore() {
            return score;
        }
    }

    private static class RelicMatchScore {
        private final CulturalRelic relic;
        private final int score;
        private final int matchedKeywordCount;
        private final List<String> matchTags;

        private RelicMatchScore(CulturalRelic relic, int score, int matchedKeywordCount, List<String> matchTags) {
            this.relic = relic;
            this.score = score;
            this.matchedKeywordCount = matchedKeywordCount;
            this.matchTags = matchTags;
        }

        public CulturalRelic getRelic() {
            return relic;
        }

        public int getScore() {
            return score;
        }

        public int getMatchedKeywordCount() {
            return matchedKeywordCount;
        }

        public List<String> getMatchTags() {
            return matchTags;
        }
    }

    private static class KeywordScore {
        private final int score;
        private final List<String> tags;

        private KeywordScore(int score, List<String> tags) {
            this.score = score;
            this.tags = tags;
        }

        public int getScore() {
            return score;
        }

        public List<String> getTags() {
            return tags;
        }
    }
}
