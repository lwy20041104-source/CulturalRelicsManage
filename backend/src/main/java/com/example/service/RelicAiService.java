package com.example.service;

import com.example.dto.AiRelicQueryResponse;

public interface RelicAiService {
    AiRelicQueryResponse queryRelics(String question, Boolean matchAll);
}
