# -*- coding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = "quacks"
  s.version = "0.0.0"
  s.date = "2012-03-24"
  s.summary = "Quotes for users"
  s.description = "A system for handling quotes with a user base"
  s.authors = ["Jürgen Bickert"]
  s.email = "juergen.bickert@gmail.com"
  s.files = Dir.glob("{lib,core,presenter}/**/*.rb")
  s.add_dependency "log4r"
end