output "example" {
  description = "Example output"
  value       = local.example 
}

output "random" {
  description = "Stable random number for this example"
  value       =  join("", random_integer.example[*].result)
}