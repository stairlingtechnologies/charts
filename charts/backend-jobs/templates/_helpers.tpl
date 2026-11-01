{{/*
Expand the name of the chart.
*/}}
{{- define "jobs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jobs.fullname" -}}
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
{{- define "jobs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jobs.labels" -}}
helm.sh/chart: {{ include "jobs.chart" . }}
{{ include "jobs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jobs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jobs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "jobs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "jobs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the stairling image name
*/}}
{{- define "jobs.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end }}

{{/*
Create the stairling migration image name
*/}}
{{- define "jobs.image.migration" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s-migration:%s" .Values.image.repository $tag }}
{{- end }}

{{/*
Create the stairling tranfer creation job image name
*/}}
{{- define "jobs.image.transferCreation" -}}
{{- $tag := .Values.image.transferCreation.tag | default "latest" }}
{{- printf "%s:%s" .Values.image.transferCreation.repository $tag }}
{{- end }}

{{/*
Create the stairling tranfer status job image name
*/}}
{{- define "jobs.image.transferStatusUpdate" -}}
{{- $tag := .Values.image.transferStatusUpdate.tag | default "latest" }}
{{- printf "%s:%s" .Values.image.transferStatusUpdate.repository $tag }}
{{- end }}

{{/*
Create metrics bind address
*/}}
{{- define "jobs.metricsAddress" -}}
{{- printf "%s:%s" .Values.operator.listenAddress .Values.operator.metricsPort }}
{{- end }}

{{/*
Create probe bind address
*/}}
{{- define "jobs.probeAddress" -}}
{{- printf "%s:%s" .Values.operator.listenAddress .Values.operator.probePort }}
{{- end }}
