# Changelog for DscConfig.Demo

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added check to prevent the build running in PS7+.
- Removed hard-coded resources.
- Updated M365DSC to 1.23.830.1.

## [0.2.2] - 2023-04-19

### Changed

- Updated M365DSC to 1.23.412.1

### Added

- Added 'EXTransportConfig' config with test data.

## [0.2.1] - 2023-01-15

### Changed

- Updated pipeline to latest version of Sampler.

## [0.2.0] - 2022-10-11

### Added

- Initial Release.
- Added configuration `ADAuthorizationPolicies`.
- Added configuration `ADRoleSettings`.
- Added configuration `ADSecurityDefaults`.

### Fixed

- Fixed resource `ADGroupSettings` according to `IsSingleInstance`.
