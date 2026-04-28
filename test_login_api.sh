#!/bin/bash
# 测试登录API返回的错误信息

echo "=== 测试1：密码错误 ==="
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"wrong","roleCode":"ADMIN"}' \
  -w "\nHTTP Status: %{http_code}\n" \
  -s | jq .

echo ""
echo "=== 测试2：再次密码错误 ==="
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"wrong","roleCode":"ADMIN"}' \
  -w "\nHTTP Status: %{http_code}\n" \
  -s | jq .
