# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- ...

## [0.2.1] - 2020-10-21
### Added
- Implicit passing of method name to the decorators
- Syntax validation
- Decorator validation (ensure decorator method is defined)

### Changed
- Syntax changes that require decorators to be declared immediately before a method definition

### Fixed
- Loading of custom exceptions

## [0.2.0] - 2020-10-16
### Added
- Ability to declare multiple decorators on a method
- Syntactic sugar `wrapper` as a means of declaring and returning a block inside a decorator method

### Changed
- Switched from simple nested method evaluation to a more powerful passing of functions that evaluate from outside-in


## [0.1.0] - 2020-10-15
### Added
- initial gem creation
