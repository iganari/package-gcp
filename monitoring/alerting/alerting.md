<@here>  
<here>  
<!here>  
<@channel>  
<channel>  
<!channel>  
${condition.display_name} からの Latency が 500ms を超えました
状況の確認をしてください  
[Uptime Check](Link)

[変数表](https://cloud.google.com/monitoring/alerts/doc-variables#doc-vars)  
1 = ${condition.name}
2 = ${condition.display_name}  
3.1 = ${metadata.system_label.*}  
3.2 = ${metadata.system_label.\*}  
4.1 = ${metadata.user_label.*}  
4.2 = ${metadata.user_label.\*} 
5 = ${metric.type}  
6 = ${metric.display_name}  
7.1 = ${metric.label.*}  
7.2 = ${metric.label.\*}  
8 = ${policy.name}  
9 = ${policy.display_name}  
10.1 = ${policy.user_label.*}  
10.2 = ${policy.user_label.\*}  
11 = ${project}  
12 = ${resource.type}  
13 = ${resource.project}  
14.1 = ${resource.label.*}  
14.2 = ${resource.label.\*}  
