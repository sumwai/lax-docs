# lax-docs

lax 的公开文档内容。仓库里只有 Markdown / MDX 页面与各级 `meta.json`，没有站点代码、依赖清单与样式：渲染、搜索、Markdown 原文、`llms.txt` 与 OG 图都由框架仓库提供。

框架是同级目录下的 `docs-site`，构建前由框架的 `scripts/fetch-content.mjs` 把 `content/docs` 同步进去。

## 结构

| 路径 | 内容 |
| --- | --- |
| `content/docs/meta.json` | 侧边栏一级顺序与分组线 |
| `content/docs/*.mdx` | 顶层页面：概览、安装、快速开始、客户端接入、用量、术语、常见问题、Agent 入口 |
| `content/docs/<分组>/` | 分组页面与同级 `meta.json`：供应商与路由、账号、模型、网关与协议、命令行参考 |

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

站点构建、镜像与反向代理的说明在框架仓库的 `README.md`。远程拉取内容时用 `DOCS_CONTENT_REPO=<owner>/lax-docs` 指向本仓库，`DOCS_CONTENT_REF` 写 tag 固定版本。
