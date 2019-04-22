{{/* vim: set filetype=mustache: */}}

{{- define "additional-scrape-configs.yaml" -}}
{{- $root := . -}}
{{- $yamls := dict -}}
{{- if eq .Values.level "cluster" -}}
  {{- range $path, $bytes := .Files.Glob "additionals/c-scrape_*.yaml" -}}
    {{- $tpl := tpl ($bytes | toString) $root }}
    {{- if $tpl }}
    {{- $_ := set $yamls $tpl "" -}}
    {{- end }}
  {{- end -}}
{{- end -}}
{{- range $path, $bytes := .Files.Glob "additionals/w-scrape_*.yaml" -}}
  {{- $tpl := tpl ($bytes | toString) $root }}
  {{- if $tpl }}
  {{- $_ := set $yamls $tpl "" -}}
  {{- end }}
{{- end -}}
{{- if .Values.additionalScrapeConfigs -}}
  {{- $_ := set $yamls (.Values.additionalScrapeConfigs | toYaml) "" -}}
{{- end -}}
{{- if $yamls -}}
  {{- keys $yamls | join "\n" | quote -}}
{{- end -}}
{{- end -}}


{{- define "additional-alertmanager-configs.yaml" -}}
{{- $root := . -}}
{{- $yamls := dict -}}
{{- if eq .Values.level "cluster" -}}
  {{- range $path, $bytes := .Files.Glob "additionals/c-altermanager_*.yaml" -}}
    {{- $tpl := tpl ($bytes | toString) $root }}
    {{- if $tpl }}
    {{- $_ := set $yamls $tpl "" -}}
    {{- end }}
  {{- end -}}
{{- end -}}
{{- range $path, $bytes := .Files.Glob "additionals/w-altermanager_*.yaml" -}}
  {{- $tpl := tpl ($bytes | toString) $root }}
  {{- if $tpl }}
  {{- $_ := set $yamls $tpl "" -}}
  {{- end }}
{{- end -}}
{{- if .Values.additionalAlertManagerConfigs -}}
  {{- $_ := set $yamls (.Values.additionalAlertManagerConfigs | toYaml) "" -}}
{{- end -}}
{{- if $yamls -}}
  {{- keys $yamls | join "\n" | quote -}}
{{- end -}}
{{- end -}}


{{- define "app.auth.fullname" -}}
{{- $name := include "app.name" . -}}
{{- printf "%s-auth-%s" $name .Release.Name -}}
{{- end -}}

{{- define "serviceMonitor.namespace.selector" -}}
{{- $root := . -}}
{{- $yamls := dict -}}
{{- $selector := .Values.serviceMonitorNamespaceSelector -}}
{{- $expersion := default list (index $selector "matchExpressions") -}}
{{- if eq .Values.level "project" -}}
{{- $projectContent := dict -}}
{{- $_ := set $projectContent "key" "field.cattle.io/projectId" -}}
{{- $_ := set $projectContent "operator" "In" -}}
{{- $_ := set $projectContent "values" (list .Values.global.projectName) -}}
{{- $_ := set $selector "matchExpressions"  (append $expersion $projectContent) -}}
{{- end -}}
{{- $_ := set $yamls "serviceMonitorNamespaceSelector" $selector -}}
{{- toYaml $yamls | indent 2 -}}
{{- end -}}

{{- define "rule.namespace.selector" -}}
{{- $root := . -}}
{{- $yamls := dict -}}
{{- $selector := .Values.ruleNamespaceSelector -}}
{{- $expersion := default list (index $selector "matchExpressions") -}}
{{- if eq .Values.level "project" -}}
{{- $projectContent := dict -}}
{{- $_ := set $projectContent "key" "field.cattle.io/projectId" -}}
{{- $_ := set $projectContent "operator" "In" -}}
{{- $_ := set $projectContent "values" (list .Values.global.projectName) -}}
{{- $_ := set $selector "matchExpressions"  (append $expersion $projectContent) -}}
{{- end -}}
{{- $_ := set $yamls "ruleNamespaceSelector" $selector -}}
{{- toYaml $yamls | indent 2 -}}
{{- end -}}

{{- define "rule.selector" -}}
{{- $root := . -}}
{{- $yamls := dict -}}
{{- $selector := .Values.ruleSelector -}}
{{- $expersion := default list (index $selector "matchExpressions") -}}
{{- if eq .Values.level "project" -}}
{{- $projectContent := dict -}}
{{- $_ := set $projectContent "key" "source" -}}
{{- $_ := set $projectContent "operator" "In" -}}
{{- $_ := set $projectContent "values" (list "rancher-alert") -}}
{{- $_ := set $selector "matchExpressions"  (append $expersion $projectContent) -}}
{{- end -}}
{{- $_ := set $yamls "ruleSelector" $selector -}}
{{- toYaml $yamls | indent 2 -}}
{{- end }}