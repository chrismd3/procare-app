# Changelog

## [0.2.52] (Unreleased)
- Bundler 2.2.28 specs support
- Bundler 2.2.29 specs support
- Bundler 2.2.30 specs support
- Bundler 2.2.31 specs support
- Bundler 2.2.32 specs support
- Bundler 2.2.33 specs support
- Ruby 3.0.3 support
- Ruby 3.1.0 support
- Update jruby to jruby-9.3.1.0

## [0.2.51] (2021-09-09)
- Fix #172 - `bundle secure` not working without `.diffend.yml`

## [0.2.50] (2021-08-19)
- Fix #132 - `bundle` without command name fails to recognize that first argument is an option
- Bundler 2.2.26 specs support
- Bundler 2.2.27 specs support

## [0.2.49] (2021-08-11)
- Bundler 2.2.20 specs support
- Bundler 2.2.21 specs support
- Bundler 2.2.22 specs support
- Bundler 2.2.23 specs support
- Bundler 2.2.24 specs support
- Bundler 2.2.25 specs support

## [0.2.48] (2021-05-31)
- Add Windows host user detection

## [0.2.47] (2021-05-31)
- Bundler 2.2.18 support
- Bundler 2.2.19 support
- Windows support

## [0.2.46] (2021-05-05)
- Optimized file selection to make releases smaller and easier to read through.

## [0.2.45] (2021-05-05)
- Bundler 2.2.17 support

## [0.2.44] (2021-03-31)
- `project_id`, `shareable_id` and `shareable_key` need to be a valid UUID

## [0.2.43] (2021-03-16)
- introduce `DIFFEND_TAGS` ([#119](https://github.com/diffend-io/diffend-ruby/pull/119))
- add support for `bundle add` command ([#118](https://github.com/diffend-io/diffend-ruby/pull/118))

## [0.2.42] (2021-03-09)
- introduce `DIFFEND_SKIP_DENY` flag
- fix config not being passed properly to `build_error` in `Diffend::Execute` ([#116](https://github.com/diffend-io/diffend-ruby/pull/116))

## [0.2.41] (2021-03-09)
- introduce integration specs ([#107](https://github.com/diffend-io/diffend-ruby/pull/107))
- use `Bundler::Definition.resolve` for specs ([#112](https://github.com/diffend-io/diffend-ruby/pull/112))

## [0.2.40] (2021-02-23)
- don't expose ips, we can identify instance by a hostname ([#108](https://github.com/diffend-io/diffend-ruby/pull/108))
- don't set `verify_mode` when creating request in `Diffend::Request`, use default value set by `use_ssl` flag instead ([#109](https://github.com/diffend-io/diffend-ruby/pull/109))

## [0.2.39] (2021-01-18)
- handle a case if we start to fast and some gems require things it may break the execution ([#101](https://github.com/diffend-io/diffend-ruby/pull/101))

## [0.2.38] (2021-01-15)
- allow executing `bundle secure` without plugin being present in the Gemfile ([#96](https://github.com/diffend-io/diffend-ruby/pull/96))
- be explicit about `Bundler` scope ([#97](https://github.com/diffend-io/diffend-ruby/pull/97))
- switch to exponential backoff in `Diffend::Monitor` ([#98](https://github.com/diffend-io/diffend-ruby/pull/98))

## [0.2.37] (2021-01-05)
- add support for ENV loaded at runtime ([#92](https://github.com/diffend-io/diffend-ruby/pull/92))
- allow us to have more control over config errors ([#91](https://github.com/diffend-io/diffend-ruby/pull/91))
- add `bundle secure` command ([#90](https://github.com/diffend-io/diffend-ruby/pull/90))
- test against bundler 2.1 and 2.2 ([#83](https://github.com/diffend-io/diffend-ruby/pull/83))
- test against ruby 3.0.0 ([#89](https://github.com/diffend-io/diffend-ruby/pull/89))
- simplify how we build full json in specs  ([#82](https://github.com/diffend-io/diffend-ruby/pull/82))
- simplify how we build bundler json in specs ([#84](https://github.com/diffend-io/diffend-ruby/pull/84))
- simplify how we build diffend json in specs ([#85](https://github.com/diffend-io/diffend-ruby/pull/85))
- simplify how we build rubygems json in specs ([#86](https://github.com/diffend-io/diffend-ruby/pull/86))
- simplify how we build packages platforms json in specs ([#87](https://github.com/diffend-io/diffend-ruby/pull/87))

## [0.2.36] (2020-12-06)
- handle `Bundler::PermissionError` ([#79](https://github.com/diffend-io/diffend-ruby/pull/79))
- use cache to resolve dependencies in exec mode ([#78](https://github.com/diffend-io/diffend-ruby/pull/78))

## [0.2.35] (2020-11-04)
- clean command name and title of a process ([#76](https://github.com/diffend-io/diffend-ruby/pull/76))
- handle `uninitialized constant #<Class:Diffend::Configs::Fetcher>::ERB` ([#75](https://github.com/diffend-io/diffend-ruby/pull/75))

## [0.2.34] (2020-10-25)
- handle `Bundler::GitError` ([#72](https://github.com/diffend-io/diffend-ruby/pull/72))

## [0.2.33] (2020-10-25)
- fix an exception when configuration file is missing ([#65](https://github.com/diffend-io/diffend-ruby/pull/65))
- silently exit when configuration file is missing in `Diffend::Monitor` ([#66](https://github.com/diffend-io/diffend-ruby/pull/66))
- introduce default config ([#67](https://github.com/diffend-io/diffend-ruby/pull/67))
- handle `SocketError` ([#68](https://github.com/diffend-io/diffend-ruby/pull/68))

## [0.2.32] (2020-10-02)
- fix how we build platform from `Gem::Platform` ([#56](https://github.com/diffend-io/diffend-ruby/pull/56))
- introduce `Diffend::LatestVersion` ([#57](https://github.com/diffend-io/diffend-ruby/pull/57))
- refactor `Diffend::Config` ([#58](https://github.com/diffend-io/diffend-ruby/pull/58))
- set command in `Diffend::Config` ([#59](https://github.com/diffend-io/diffend-ruby/pull/59))
- introduce `Diffend::Logger` ([#60](https://github.com/diffend-io/diffend-ruby/pull/60))
- set severity to `FATAL` in `Diffend::Monitor` ([#61](https://github.com/diffend-io/diffend-ruby/pull/61))
- handle `Bundler::VersionConflict` ([#62](https://github.com/diffend-io/diffend-ruby/pull/62))

## [0.2.31] (2020-09-24)
- change request timeout to 15 seconds ([#53](https://github.com/diffend-io/diffend-ruby/pull/53))
- report request issues as warnings ([#54](https://github.com/diffend-io/diffend-ruby/pull/54))

## [0.2.30] (2020-09-21)
- handle dependencies resolve issues ([#51](https://github.com/diffend-io/diffend-ruby/pull/51))
- better detection when to start `Diffend::Monitor` ([#50](https://github.com/diffend-io/diffend-ruby/pull/50))
- cleanup structure ([#47](https://github.com/diffend-io/diffend-ruby/pull/47))

## [0.2.29] (2020-09-21)
- fix command reporting on jruby ([#48](https://github.com/diffend-io/diffend-ruby/pull/48))

## [0.2.28] (2020-09-19)
- start `Diffend::Monitor` only if not in development or test ([#44](https://github.com/diffend-io/diffend-ruby/pull/44))
- better host command expose ([#45](https://github.com/diffend-io/diffend-ruby/pull/45))

## [0.2.27] (2020-09-16)
- introduce `Diffend::RequestObject` ([#40](https://github.com/diffend-io/diffend-ruby/pull/40))
- clean up error codes and introduce `DIFFEND_INGORE_EXCEPTIONS` ([#41](https://github.com/diffend-io/diffend-ruby/pull/41))
- introduce `Diffend::Monitor` and `Diffend::Track` ([#15](https://github.com/diffend-io/diffend-ruby/pull/15))

## [0.2.26] (2020-09-10)
- introduce `DIFFEND_DEVELOPMENT` environment variable ([#36](https://github.com/diffend-io/diffend-ruby/pull/36))
- adjust message for allow verdict ([#37](https://github.com/diffend-io/diffend-ruby/pull/37))
- do not run the plugin when it is not enabled ([#38](https://github.com/diffend-io/diffend-ruby/pull/38))

## [0.2.25] (2020-09-09)
- add support for a warn verdict ([#34](https://github.com/diffend-io/diffend-ruby/pull/34))

## [0.2.24] (2020-09-08)
- better error handling of response ([#28](https://github.com/diffend-io/diffend-ruby/pull/28))
- fix jruby specs ([#29](https://github.com/diffend-io/diffend-ruby/pull/29))
- handle request server errors ([#30](https://github.com/diffend-io/diffend-ruby/pull/30))
- better detection of gem source ([#31](https://github.com/diffend-io/diffend-ruby/pull/31))
- detect if we are running outdated version of the plugin ([#32](https://github.com/diffend-io/diffend-ruby/pull/32))

## [0.2.23] (2020-09-06)
- fix how we build gem platform ([#26](https://github.com/diffend-io/diffend-ruby/pull/26))
- test against jruby, ruby-2.5 and ruby-2.6 ([#25](https://github.com/diffend-io/diffend-ruby/pull/25))

## [0.2.22] (2020-09-03)
- fix how we build host command

## [0.2.21] (2020-09-03)
- bring back support for ruby 2.5.x

## [0.2.20] (2020-09-03)
- expose host command ([#21](https://github.com/diffend-io/diffend-ruby/pull/21))
- expose host pid ([#20](https://github.com/diffend-io/diffend-ruby/pull/20))
- use `Bundler.feature_flag.default_cli_command` which is used as the default task if no command provided, instead of `Diffend::Commands::INSTALL` ([#19](https://github.com/diffend-io/diffend-ruby/pull/19))
- better error handling ([#18](https://github.com/diffend-io/diffend-ruby/pull/18))
- better detection of gem versions ([#17](https://github.com/diffend-io/diffend-ruby/pull/17))
- introduce `Diffend::BuildBundlerDefinition` ([#16](https://github.com/diffend-io/diffend-ruby/pull/16))

## [0.2.19] (2020-08-18)

- better detection of gem sources ([#13](https://github.com/diffend-io/diffend-ruby/pull/13))

## [0.2.18] (2020-08-05)

- use `Etc.getpwuid` instead of `Etc.getlogin` for fetching host user ([#11](https://github.com/diffend-io/diffend-ruby/pull/11))

## [0.2.17] (2020-08-05)

- introduce config validation ([#9](https://github.com/diffend-io/diffend-ruby/pull/9))

## [0.2.16] (2020-07-28)

- report unexpected errors ([#8](https://github.com/diffend-io/diffend-ruby/pull/8))

## 0.2.15 (2020-06-07)

- initial release

[master]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.44...HEAD
[0.2.44]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.43...v0.2.44
[0.2.43]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.42...v0.2.43
[0.2.42]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.41...v0.2.42
[0.2.41]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.40...v0.2.41
[0.2.40]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.39...v0.2.40
[0.2.39]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.38...v0.2.39
[0.2.38]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.37...v0.2.38
[0.2.37]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.36...v0.2.37
[0.2.36]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.35...v0.2.36
[0.2.35]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.34...v0.2.35
[0.2.34]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.33...v0.2.34
[0.2.33]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.32...v0.2.33
[0.2.32]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.31...v0.2.32
[0.2.31]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.30...v0.2.31
[0.2.30]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.29...v0.2.30
[0.2.29]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.28...v0.2.29
[0.2.28]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.27...v0.2.28
[0.2.27]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.26...v0.2.27
[0.2.26]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.25...v0.2.26
[0.2.25]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.24...v0.2.25
[0.2.24]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.23...v0.2.24
[0.2.23]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.22...v0.2.23
[0.2.22]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.21...v0.2.22
[0.2.21]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.20...v0.2.21
[0.2.20]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.19...v0.2.20
[0.2.19]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.18...v0.2.19
[0.2.18]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.17...v0.2.18
[0.2.17]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.16...v0.2.17
[0.2.16]: https://github.com/diffend-io/diffend-ruby/compare/v0.2.15...v0.2.16
