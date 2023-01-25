{{- define "cluster-issuer-ca-secret" -}}
{{- printf "%s-%s" .Values.certIssuer.name "ca-secret" -}}
{{- end -}}
