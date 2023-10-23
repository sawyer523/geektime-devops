# week7 homework
> 请使用 Matrix Generator 组合以下两个 Generator：Git Generator、Cluser Generator，并通过一个 ApplicationSet 对象将 demo-5 的 dev 和 staging 环境部署部署到两个集群内（每个集群都有两套相同的环境）。

* 这个ApplicationSet配置的主要功能是:

1. 使用 git generator 从指定的仓库路径生成应用清单。

1. 使用 clusters generator 从集群列表中生成集群信息。

1. 为每个应用配置自动 image updater,实现 GitOps 自动部署流程。