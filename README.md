# Cloudflare_AutoNAT
首先声明，此项目是调用[XUI2/CloudflareSpeedtest](https://github.com/XIU2/CloudflareSpeedTest)做核心筛选工作，IP质量得以保证，在此为基础编写程序以实现自动化与端口转发，
［Cloudflare_AutoNAT］:在CloudflareST作为优选IP基础，做出的自动化方案,,定时筛选优选IP，并自动更换最优IP。Cloudflare_AutoNAT会帮忙筛选最优ip并进行端口转发，无需自行筛选更换，Clouflare_AutoNAT为此为目的开发，目前只支持Linux版本，，（毕竟才刚刚开始嘛）
目前阶段还在自测中,发现bug在修复,有能力的可以尝试自行解决,大体bug已修复,主体功能已完善


# 免责声明
Cloudflare_AutoNAT 相关项目仅供教育、研究和安全测试目的而设计和开发。本项目旨在为安全研究人员、学术界人士及技术爱好者提供一个探索和实践网络通信技术的工具。
在下载和使用本项目代码时，使用者必须严格遵守其所适用的法律和规定。使用者有责任确保其行为符合所在地区的法律框架、规章制度及其他相关规定。


### 使用条款

- **教育与研究用途**：本软件仅可用于网络技术和编程领域的学习、研究和安全测试。
- **禁止非法使用**：严禁将 **Cloudflare_AutoNAT** 用于任何非法活动或违反使用者所在地区法律法规的行为。
- **使用时限**：基于学习和研究目的，建议用户在完成研究或学习后，或在安装后的**24小时内，删除本软件及所有相关文件。**
- **免责声明**：**Cloudflare_AutoNAT** 的创建者和贡献者不对因使用或滥用本软件而导致的任何损害或法律问题负责。
- **用户责任**：**用户对使用本软件的方式以及由此产生的任何后果完全负责。**
- **无技术支持**：本软件的创建者不提供任何技术支持或使用协助。
- **知情同意**：使用 **Cloudflare_AutoNAT** 即表示您已阅读并理解本免责声明，并同意受其条款的约束。

**请记住**：本软件的主要目的是促进学习、研究和安全测试。作者不支持或认可任何其他用途。使用者应当在合法和负责任的前提下使用本工具。

---
****
## \# 快速使用

### 文件结构简介
# Cloudflare AutoNAT

Cloudflare AutoNAT 是一个自动化脚本，旨在通过 Cloudflare 提供的服务进行端口转发和 IP 替换。该项目包含多个脚本和配置文件，便于用户快速设置和使用。


## 文件说明

- **canat.sh**: 该脚本是项目的主入口，负责执行主要的自动化任务。
- **set_cron_jobs.sh**: 该脚本用于设置定时任务，默认配置为每天凌晨3点执行。
- **socat/**: 该目录包含与端口转发相关的文件。
  - **port.txt**: 配置本地与 CDN 的端口映射。
  - **socat.sh**: 端口转发的配置脚本，负责启动 socat 服务。
  - **target_IP.sh**: 检测端口转发配置并进行 IP 替换的脚本。
- **CloudflareST/**: 该目录包含 CloudflareST 项目的相关文件。
  - **CloudflareST**: CloudflareST 的主程序文件。
  - **用法.md**: 提供 CloudflareST 的使用说明和示例。
  - **cfst_hosts.sh**: CloudflareST 的辅助脚本，用于处理主程序的相关任务。
  - **ip.txt**: 存储可用的 IP 地址列表。
  - **ipv6.txt**: 存储可用的 IPv6 地址列表。
- **README.md**: 本文件，提供项目的概述和使用说明。
- **ip.txt**: 该文件包含 `run_cloudflare.sh` 所需的 IP 地址库。

- 
### 下载运行
1. 下载编译好的可执行文件（[Github Releases]([https://github.com/ASuzuhA/Cloudflare_AutoNAT/releases)
- **注意**：文件路径必须放到/root目录下，，即是/root/canat/xxx......

<summary><code><strong>「 Linux 系统下的使用示例 」</strong></code></summary>

``` yaml
#进项目目录
cd /root/canat

# 赋予执行权限
chmod +x canat.sh

# 运行
./canat.sh
```


****

## 感谢项目

- _https://github.com/XIU2/CloudflareSpeedTest_
- _http://www.dest-unreach.org/socat/
  
> _感谢CloudflareSpeedTest项目提供核心技术支持，送朵小花花表示感谢_(•̀ω•́ 」∠)_ _  
> _本软件基于该项目制作，做了点自动化设置，灵感来自CFNAT_
 
****

