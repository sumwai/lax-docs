.PHONY: docs-install docs-content docs docs-build docs-preview

# 站点框架是独立仓库，默认取同级 checkout；换位置时改 DOCS_SITE_DIR。
DOCS_SITE_DIR ?= ../docs-site
DOCS_PORT ?= 3000

# 品牌与语言通过环境变量交给框架，本仓库不放站点代码与站点配置。
# 构建时决定页面文案，start 时 robots.txt 与 llms.txt 还要再读一次，
# 所以 docs-preview 的两步都带上同一组值。
export DOCS_SITE_NAME ?= larkax
export DOCS_SITE_TAGLINE ?= 默认入口 larkax.com，也可以自部署
export DOCS_SITE_DESCRIPTION ?= 客户端把 Claude Code、Codex、OpenAI、Anthropic 与 Gemini SDK 指向同一个地址；八种线协议可进可出，其中四种对话协议之间可以互相转换。默认使用 larkax.com，也可以在自己的主机上部署同一套网关。
export DOCS_SITE_LOCALE ?= zh-CN

# 框架的同步脚本按这个变量找到本仓库的内容目录，再复制进它的 content/docs。
# 变量指向内容目录本身（有 meta.json 的那一层），不是仓库根目录。
export DOCS_CONTENT_DIR := $(CURDIR)/content/docs

docs-install:
	cd $(DOCS_SITE_DIR) && npm install --no-audit --no-fund

docs-content: docs-install
	cd $(DOCS_SITE_DIR) && node scripts/fetch-content.mjs

docs: docs-content
	cd $(DOCS_SITE_DIR) && npm run dev -- --port $(DOCS_PORT)

docs-build: docs-content
	cd $(DOCS_SITE_DIR) && npm run build

docs-preview: docs-content
	cd $(DOCS_SITE_DIR) && NEXT_PUBLIC_SITE_URL=http://127.0.0.1:$(DOCS_PORT) npm run build
	cd $(DOCS_SITE_DIR) && NEXT_PUBLIC_SITE_URL=http://127.0.0.1:$(DOCS_PORT) npm run start -- --port $(DOCS_PORT)
