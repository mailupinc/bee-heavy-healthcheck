# 1. Start using ADR (Architecture Decision Records) to document project

Date: 2020-07-22

## Status

Proposed

## Context

We need a way to document the relevant decisions on a project.

We want a quick way to do that.

We want a history of decisions taken

We dont want a long document to update

## Decision

We will use Architecture Decision Records in the `./doc/adr` directory

Some sources on this practice:

Described by:

- [by Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).
- [by Nicolas Carlo](https://understandlegacycode.com/blog/earn-maintainers-esteem-with-adrs/)

A tool to ease the creation of new ADR item

- [bash tool](https://github.com/npryce/adr-tools)

### Examples of `adr` command

Example of initialization in a project

```shel
$ adr init doc/adr
doc/adr/0001-record-architecture-decisions.md
```

Example of new entry creation

```shell
$ adr new Changed Lorem to Ipsum
doc/adr/0002-changed-lorem-to-ipsum.md

```

## Consequences

Everyone can review relevant decisions made during the life of a project

### ADR file sections

This is the description present in [Michael Nygard post](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions)
I paste it here because the original post sometimes it's not reachable

**Title**: These documents have names that are short noun phrases. For example, "ADR 1: Deployment on Ruby on Rails 3.0.10" or "ADR 9: LDAP for Multitenant Integration"

**Context**: This section describes the forces at play, including technological, political, social, and project local. These forces are probably in tension, and should be called out as such. The language in this section is value-neutral. It is simply describing facts.

**Decision**: This section describes our response to these forces. It is stated in full sentences, with active voice. "We will ..."

**Status**: A decision may be "proposed" if the project stakeholders haven't agreed with it yet, or "accepted" once it is agreed. If a later ADR changes or reverses a decision, it may be marked as "deprecated" or "superseded" with a reference to its replacement.

**Consequences**: This section describes the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences, but all of them affect the team and project in the future.

**notes**: The whole document should be one or two pages long. We will write each ADR as if it is a conversation with a future developer. This requires good writing style, with full sentences organized into paragraphs. Bullets are acceptable only for visual style, not as an excuse for writing sentence fragments. (Bullets kill people, even PowerPoint bullets.)
