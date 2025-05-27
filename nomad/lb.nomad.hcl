variable "consul_domain" {
  description = "The consul domain for DNS. This is usually .consul in most configurations. Do not include the dot (.) in the value, just the name."
  default = "global"
}

job "terramino-proxy" {
  type = "system"
  
  group "terramino-proxy" {
    network {
      port "proxy" {
        static = 4444
      }
      dns {
        servers = ["172.17.0.1"]
      }
    }

    restart {
      attempts = 30
      delay = "30s"
    }

    service {
      name     = "terramino-proxy"
      port     = "proxy"
      provider = "consul"

      check {
        type = "http"
        name = "proxy health"
        path = "/health"
        interval = "20s"
        timeout = "5s"
      }
    }

    task "terramino-proxy-task" {
      driver = "docker"

      config {
        image = "nginx"
        ports = ["proxy"]
        mount {
          type   = "bind"
          source = "local/default.conf"
          target = "/etc/nginx/conf.d/default.conf"
        }
      }
      template {
        data        = <<EOF
          server {
            listen 4444;
            server_name {{ env "NOMAD_IP_proxy" }};

            # Add a health check endpoint that always returns OK
            location /health {
                access_log off;
                add_header Content-Type application/json;
                return 200 '{"status":"OK"}';
            }

            location / {
                proxy_pass http://terramino-frontend.service.dc1.${var.consul_domain}:8101;
            }
        }
        EOF
        destination = "local/default.conf"
      }
    }
  }
}