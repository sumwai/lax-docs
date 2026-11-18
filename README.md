# larkax-docs

larkax 的公开文档内容。仓库里只有 Markdown / MDX 页面与各级 `meta.json`，没有站点代码、依赖清单与样式：渲染、搜索、Markdown 原文、`llms.txt` 与 OG 图都由框架仓库提供。

框架是同级目录下的 `docs-site`，构建前由框架的 `scripts/fetch-content.mjs` 把 `content/docs` 同步进去。

## 结构

| 路径 | 内容 |
| --- | --- |
| `content/docs/meta.json` | 侧边栏一级分区的顺序 |
| `content/docs/public/overview.mdx` | 总览：larkax 是什么、从哪里读起 |
| `content/docs/public/` | 使用 larkax.com：入口、快速开始、调用接口、错误限制与数据边界 |
| `content/docs/public/clients/` | Claude Code、Codex 与各 SDK 的配置 |
| `content/docs/public/auth.mdx` | 凭据与请求头：三种 API Key 头与 401 响应 |
| `content/docs/public/troubleshooting.mdx` | 接入排查：连不上、401、404 时的检查顺序 |
| `content/docs/self-hosted/` | 自部署入口、安装、首次配置与全部管理页面 |
| `content/docs/self-hosted/concepts/` | 工作原理、账号与模型、请求生命周期 |
| `content/docs/self-hosted/configure/` | 供应商、账号、模型、价格 |
| `content/docs/self-hosted/route/` | 选号策略、权重、账号额度与解释 |
| `content/docs/self-hosted/gateway/` | 协议、转换、请求头、错误、实时、嵌入、决策、语音 |
| `content/docs/self-hosted/plugins/` | 插件安装、方言、清单与安全 |
| `content/docs/self-hosted/operate/` | 用量、日志、诊断、数据与升级 |
| `content/docs/self-hosted/faq.mdx` | 网关启动、模型、账号、协议与用量的高频问题 |
| `content/docs/self-hosted/cli.mdx` | 命令行参考：全局参数、命令分组与退出码 |
| `content/docs/reference/` | 术语与供 Agent 读取的入口 |
| `content/docs/releases/` | 版本说明与变更日志 |

新增页面要同时加同级 `meta.json` 的 `pages` 条目，否则页面能打开但侧边栏里进不去。

## 侧边栏分区

`public`、`self-hosted`、`reference`、`releases` 是四个一级分类：`public` 面向使用托管入口 `larkax.com` 的人，`self-hosted` 面向自己部署网关的管理员，`reference` 放术语与 Agent 入口，`releases` 放版本与更新日志。管理员才会用到的查表内容（命令行参考、常见问题）放在自部署里，参考只放两边都会查的术语与 Agent 入口。

分类的 `meta.json` 带 `root: true`，侧边栏顶部显示当前分类，展开后可以切换到其它分类；进入某个分类后，侧边栏只显示这个分类的页面。分区 meta 里的 `description` 是切换器里的一句说明；有 `index.mdx` 的分类用 `pagesIndex: "index"` 把它挂成分类首页，切换器指向它。

四个分类都进切换器，进入任一分类后侧边栏只显示这个分类的页面，切换器显示当前分类。`reference` 没有 `index.mdx`，切换器指向它的第一个页面（术语）。

文档站的顶层没有 `index.mdx`，`/docs` 会直接跳到第一个分类的首页（现在是 `/docs/public`），所以总览页放在 `public/overview.mdx`。

新增一级分类时，在 `content/docs/meta.json` 的 `pages` 里写目录名，并在该目录的 `meta.json` 写 `title`、`icon`、`description` 与 `root: true`，有首页时再加 `pagesIndex: "index"`。

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
| `DOCS_SITE_GITHUB` | 侧边栏底部的仓库地址；置空则只显示主题切换 |

这些变量在构建时决定页面文案，运行时还会被 `robots.txt`、`llms.txt` 这类按请求生成的响应读取，部署时构建与运行两边要给同样的值。

## 部署

站点构建与发布说明在框架仓库的 `README.md`。远程拉取内容时用 `DOCS_CONTENT_REPO=<owner>/larkax-docs` 指向本仓库，`DOCS_CONTENT_REF` 写 tag 固定版本。
