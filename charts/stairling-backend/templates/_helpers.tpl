{{/*
Expand the name of the chart.
*/}}
{{- define "stairling.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stairling.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "stairling.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "stairling.labels" -}}
helm.sh/chart: {{ include "stairling.chart" . }}
{{ include "stairling.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "stairling.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stairling.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "stairling.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stairling.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the stairling image name
*/}}
{{- define "stairling.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end }}

{{/*
Create the stairling migration image name
*/}}
{{- define "stairling.image.migration" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s-migration:%s" .Values.image.repository $tag }}
{{- end }}

{{/*
Create metrics bind address
*/}}
{{- define "stairling.metricsAddress" -}}
{{- printf "%s:%s" .Values.operator.listenAddress .Values.operator.metricsPort }}
{{- end }}

{{/*
Create probe bind address
*/}}
{{- define "stairling.probeAddress" -}}
{{- printf "%s:%s" .Values.operator.listenAddress .Values.operator.probePort }}
{{- end }}
