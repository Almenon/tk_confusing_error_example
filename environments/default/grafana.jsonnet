local _config = import 'config.jsonnet';

{
  grafana: {
    deployment: {
      apiVersion: 'apps/v1',
      kind: _config.grafana['port'],
      metadata: {
        name: _config.grafana.name,
      },
      spec: {
        selector: {
          matchLabels: {
            name: _config.grafana.name,
          },
        },
        template: {
          metadata: {
            labels: {
              name: _config.grafana.name,
            },
          },
          spec: {
            containers: [
              {
                image: 'grafana/grafana',
                name: _config.grafana.name,
                ports: [{
                    containerPort: _config.grafana.port,
                    name: 'ui',
                }],
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
          name: _config.grafana.name,
        },
        name: _config.grafana.name,
      },
      spec: {
        ports: [{
            name: '%s-ui' % _config.grafana.name,
            port: _config.grafana.port,
            targetPort: _config.grafana.port,
        }],
        selector: {
          name: _config.grafana.name,
        },
        type: 'NodePort',
      },
    },
  }
}
