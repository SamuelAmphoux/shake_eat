// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

// import ArchiveController from "./archive_controller"
// application.register("archive", ArchiveController)
import HelloController from "./hello_controller"
application.register("hello", HelloController)

import InactiveIconsClassController from "./inactive_icons_class_controller"
application.register("inactive-icons-class", InactiveIconsClassController)

import LocksController from "./locks_controller"
application.register("locks", LocksController)

import RecipesHiddenController from "./recipes_hidden_controller"
application.register("recipes-hidden", RecipesHiddenController)

import TypeTextController from "./type_text_controller"
application.register("type-text", TypeTextController)
