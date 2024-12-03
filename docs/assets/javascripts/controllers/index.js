// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"

export function eagerLoadControllersFrom(application) {
  const keys = Object.keys(parseImportmapJson())
  const paths = keys.filter(path => path.match(/_controller$/))

  paths.forEach(path => registerControllerFromPath(path, application))
}

function parseImportmapJson() {
  return JSON.parse(document.querySelector("script[type=importmap]").text).imports
}

function registerControllerFromPath(path, application) {
  let name = path
    .replace(/^controllers\//, "")
    .replace("_controller", "")
    .replace(/\//g, "--")
    .replace(/_/g, "-")

  if (!path.match(/^controllers\//)) {
    name = `ui--${name}`
  }

  console.log(name)

  if (canRegisterController(name, application)) {
    import(path)
      .then(module => registerController(name, module, application))
      .catch(error => console.error(`Failed to register controller: ${name} (${path})`, error))
  }
}

function registerController(name, module, application) {
  if (canRegisterController(name, application)) {
    application.register(name, module.default)
  }
}

function canRegisterController(name, application){
  return !application.router.modulesByIdentifier.has(name)
}

eagerLoadControllersFrom(application)
