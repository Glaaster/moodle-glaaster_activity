# Changelog

All notable user-facing changes to this plugin are documented in this file.

## 1.2.0 (2026-02-25)

- Add contextual button support for Moodle tile/grid course layout
- Improve Glaaster instance detection for edge cases
- Remove grade-related code (unused in Glaaster workflow)
- Update label strings

## 1.1.0

- Improve real-time Glaaster instance detection logic using MutationObserver
- Fix edge cases in instance validation

## 1.0.5

- Fix Moodle subpath installation URL issues

## 1.0.4

- Fix plugin ZIP packaging for Moodle upload compatibility

## 1.0.0

- Initial release: LTI 1.3 activity plugin with contextual file buttons
- Support for JPG, PNG, PDF, DOCX, PPTX, ODT, ODP file types
- Folder support with subfolder handling and special characters
- Real-time instance validation (< 500ms, event-driven)
