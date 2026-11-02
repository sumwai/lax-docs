# larkax-docs

larkax 的公开文档内容。仓库里只有 Markdown / MDX 页面与各级 `meta.json`，没有站点代码、依赖清单与样式：渲染、搜索、Markdown 原文、`llms.txt` 与 OG 图都由框架仓库提供。

框架是同级目录下的 `docs-site`，构建前由框架的 `scripts/fetch-content.mjs` 把 `content/docs` 同步进去。

## 结构

| 路径 | 内容 |
| --- | --- |
| `content/docs/meta.json` | 侧边栏一级顺序与分组线 |
| `content/docs/index.mdx` | 文档首页 |
| `content/docs/clients/` | 客户端接入入口、Claude Code、Codex、各 SDK、鉴权与排障 |
| `content/docs/self-hosted/` | 自部署入口、安装、首次配置与全部管理页面 |
| `content/docs/concepts/` | 工作原理、账号与模型、请求生命周期 |
| `content/docs/self-hosted/configure/` | 供应商、账号、模型、价格 |
| `content/docs/self-hosted/route/` | 选号策略、权重与解释 |
| `content/docs/self-hosted/gateway/` | 协议、转换、请求头、错误、实时、嵌入、决策、语音 |
| `content/docs/self-hosted/plugins/` | 插件安装、方言、清单与安全 |
| `content/docs/self-hosted/operate/` | 用量、日志、诊断、数据与升级 |
| `content/docs/reference/` | 命令行、术语、常见问题、Agent 入口 |
| `content/docs/releases/` | 版本说明与变更日志 |

新增页面要同时加同级 `meta.json` 的 `pages` 条目，否则页面能打开但侧边栏里进不去。

## 本地预览

```bash
make docs          # 127.0.0.1:3000，改文件自动刷新
make docs-build    # 生产构建，框架的类型检查一起跑
make docs-preview  # 构建后以生产模式启动
```

框架默认取 `../docs-site`，放在别处时用 `DOCS_SITE_DIR=/path/to/docs-site` 覆盖。首次运行会先装框架的 Node 依赖。

内容不从网络拉取：`make docs-content` 用 `DOCS_CONTENT_DIR` 把本仓库的 `content/docs` 同步进框架，覆盖框架自带的示例内容。

## 品牌与语言

站点名称、首页文案与语言由框架的 `site.config.ts` 读取环境变量得到，取值写在本仓库的 `Makefile` 里作为默认值：

| 变量 | 作用 |
| --- | --- |
| `DOCS_SITE_NAME` | 浏览器标题、导航标题、OG 图、`llms.txt` 与 `robots.txt` 的头部 |
| `DOCS_SITE_TAGLINE` | 首页标题上方的小字；置空则不显示 |
| `DOCS_SITE_DESCRIPTION` | 首页正文与 meta description |
| `DOCS_SITE_LOCALE` | `<html lang>` 与内置 UI 文案；以 `zh` 开头时用中文文案 |

这些变量在构建时决定页面文案，运行时还会被 `robots.txt`、`llms.txt` 这类按请求生成的响应读取，部署时构建与运行两边要给同样的值。

## 部署

站点构建与发布说明在框架仓库的 `README.md`。远程拉取内容时用 `DOCS_CONTENT_REPO=<owner>/larkax-docs` 指向本仓库，`DOCS_CONTENT_REF` 写 tag 固定版本。
