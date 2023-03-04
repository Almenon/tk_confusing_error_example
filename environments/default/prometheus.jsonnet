local _config = import 'config.jsonnet';

{
  // jsonnet extension by purpose doesn't autocomplete $
  // better to use grafana file style
  // Prometheus
  prometheus: {
    deployment: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: _config.prometheus.name,
      },
      spec: {
        minReadySeconds: 10,
        replicas: 1,
        revisionHistoryLimit: 10,
        selector: {
          matchLabels: {
            name: _config.prometheus.name,
          },
        },
        template: {
          metadata: {
            labels: {
              name: _config.prometheus.name,
            },
          },
          spec: {
            containers: [
              {
                image: 'prom/prometheus',
                imagePullPolicy: 'IfNotPresent',
                name: _config.prometheus.name,
                ports: [
                  {
                    containerPort: 9090,
                    name: 'api',
                  },
                ],
              },
            ],
          },
        },
      },
    },
    service: {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: {
        labels: {
          name: _config.prometheus.name,
        },
        name: _config.prometheus.name,
      },
      spec: {
        ports: [
          {
            name: 'prometheus-api',
            port: 9090,
            targetPort: 9090,
          },
        ],
        selector: {
          name: _config.prometheus.name,
        },
      },
    },
  },
}