locals {
  terramino_jobspec    = file("./nomad/terramino.nomad.hcl")
  latest_frontend_file = trimspace(file("latest-frontend.version"))
  latest_backend_file  = trimspace(file("latest-backend.version"))
  rendered_jobspec     = replace(replace(local.terramino_jobspec, "_TERRAMINO_FRONTEND_IMAGE", local.latest_frontend_file), "_TERRAMINO_BACKEND_IMAGE", local.latest_backend_file)
}

# Register a job
resource "nomad_job" "terramino" {
  jobspec    = local.rendered_jobspec
  depends_on = [aws_instance.public_client[0]]
}

resource "nomad_job" "loadbalancer" {
  jobspec    = file("nomad/lb.nomad.hcl")
  depends_on = [aws_instance.public_client[0]]
}