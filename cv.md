---
layout: default
title: CV
permalink: /cv/
description: Curriculum vitae of Dimitris Karakasilis, software engineer working on Linux, Kubernetes and open source infrastructure.
cv: true
updated: 2026-07-30
---

<div class="cv" markdown="1">

<div class="cv-actions" markdown="0">
  <button type="button" class="btn btn-sm btn-outline-secondary" onclick="window.print(); return false;">
    <i class="fas fa-print"></i> Print or save as PDF
  </button>
</div>

<!-- The site header and navigation already carry the name and the contact
     links, so this block is hidden on screen. Printing drops the site chrome,
     so it is restored there, where a CV does need a name on it. -->
<div class="cv-head" markdown="0">
  <h1>Dimitris Karakasilis</h1>
  <p class="cv-contact">
    <a href="mailto:dimitris@karakasilis.me">dimitris@karakasilis.me</a> |
    <a href="https://github.com/jimmykarily">github.com/jimmykarily</a> |
    <a href="https://www.linkedin.com/in/dkarakasilis">linkedin.com/in/dkarakasilis</a> |
    <a href="https://dimitris.karakasilis.me">dimitris.karakasilis.me</a>
  </p>
</div>

## Summary

I have been a professional programmer for close to twenty years, across cloud computing,
web development, platform as a service and desktop applications. Go is my language of
preference and Linux is where I am most at home. Before Go I wrote mostly Ruby.

For the past decade I have worked in open source full time, currently as an Open Source
Principal Software Engineer at Spectro Cloud and one of the core maintainers of Kairos, a
CNCF Sandbox project. My work sits close to the metal: immutable operating systems, boot
and initramfs, disk encryption backed by a TPM, secure and trusted boot, confidential
computing, and the Kubernetes machinery that keeps a fleet of such machines up to date.

I have worked remotely full time for fourteen years in teams distributed across time zones
as far apart as ten hours. I have built the office environment and the tooling to make
that work, including the collaboration practices that go with it: pair programming,
standups, planning, retrospectives and TDD.

## Skills

- **Primary:** Go, Linux, Kubernetes, containers and OCI, systemd and initramfs, Bash,
  Git, Docker
- **Security and trust:** TPM 2.0, LUKS and full disk encryption, secure boot, UKI, remote
  attestation, AMD SEV-SNP, Kata Containers, SBOM, cosign, OSV and Grype scanning
- **Build and release:** OCI image build pipelines, GitHub Actions, package build systems
  (luet, Open Build Service), multi-architecture builds, release automation
- **Cloud:** AWS, GCP, Azure, MaaS, Cluster API
- **Earlier experience:** Ruby and Ruby on Rails, JavaScript, HTML, CSS, PostgreSQL, MySQL,
  MongoDB, Elasticsearch, Redis, Python, PHP, C, Cloud Foundry, Rancher, PhoneGap, GTK,
  Delphi
- Solid mathematics and physics background
- Experienced in remote work and asynchronous collaboration
- Linux workstation: Arch Linux, Vim, Sway

## Experience

### Spectro Cloud

Open Source Principal Software Engineer
{: .cv-role}

November 2022 to present
{: .cv-dates}

[spectrocloud.com](https://www.spectrocloud.com)
{: .cv-site}

One of the core maintainers of [Kairos](https://kairos.io), a CNCF Sandbox project that
converts any Linux distribution into an immutable, self-upgrading operating system for edge
Kubernetes. It stays distribution agnostic while adding security and lifecycle features
that a normal distribution does not provide. Parts of the company's commercial product line
are built on Kairos, and I support customers when a problem reaches the OS layer.

Beyond writing and maintaining the code, I run the project in public: issue triage, review
of external contributions, documentation, releases, user support in GitHub, Slack and
Matrix, and representing the project at meetups and conferences.

Selected work:

- **Kairos Operator.** The NodeOp and NodeOpUpgrade CRDs and their controller, which roll
  an operating system upgrade across a Kubernetes fleet. Control-plane-first ordering,
  cordon and drain with tracking of which component cordoned a node, uncordon on failure,
  pre-flight checks that skip nodes already at the target version, configurable
  concurrency, stop-on-failure, image pull secrets, and exclusion of host-managed paths
  with safe defaults.
- **AuroraBoot.** The Kairos build service that produces ISOs, netboot artifacts, cloud
  images and UKI images from any base image. My work includes the HTTP Factory API, the web
  UI and its build history, support for private and insecure registries, architecture
  selection when pulling images, MaaS curtin hooks, and a large amount of refactoring and
  UX work.
- **Trusted boot and encryption.** Consolidated the UKI and non-UKI encryption and
  decryption flows in the Kairos SDK, implemented an attestation key manager in
  tpm-helpers, added remote attestation against a KMS to the kcrypt discovery challenger,
  and fixed ordering problems between mounting and decryption in immucore, the Kairos
  initramfs.
- **Confidential computing.** SEV-SNP and confidential containers support in Hadron, plus
  upstream contributions to Kata Containers to build the host binaries and payload
  statically so they run on musl-only hosts.
- **Supply chain security.** Introduced OSV and Grype scanning across the release pipelines
  with a policy that distinguishes actionable findings from upstream noise, cosign bundle
  attestation, and an SBOM extractor for OCI image attestations.
- **Cloud publication.** OIDC authentication flows and automated image publication for AWS,
  GCP and Azure, with smoke tests on each provider.
- **Ecosystem.** Contributions to related projects including yip, edgevpn, luet, k3s, ghw
  and LocalAI.

Technologies: Go, Linux, Kubernetes, systemd, initramfs, TPM 2.0, secure boot, UKI,
SEV-SNP, containers, Bash.

### SUSE

Open Source Software Engineer
{: .cv-role}

December 2016 to November 2022
{: .cv-dates}

[suse.com](https://www.suse.com)
{: .cv-site}

I led [Epinio](https://github.com/epinio/epinio), a tool that brings a platform as a
service experience to Kubernetes. Before that I worked on the containerised Cloud Foundry
PaaS (kubecf) and the corresponding SUSE product, CAP. Among my contributions there was
work on Eirini, the component that replaces the original Cloud Foundry scheduler, Diego,
with Kubernetes, allowing Cloud Foundry workloads to run on the same cluster as Cloud
Foundry itself or on any existing Kubernetes cluster.

Other responsibilities:

- Worked on the CaaSP product, a Kubernetes cluster creation solution, in the early stages,
  helping the team build the product dashboard in Ruby on Rails (the Velum component of
  CaaSP v3).
- Moved parts of the build pipeline from Concourse to the Open Build Service.
- Extracted and reimplemented the groot-btrfs driver for the Garden component when upstream
  support ended.
- Implemented development workflows based on lightweight Kubernetes clusters (microk8s,
  kind).
- Implemented Concourse pipelines for the various build requirements of the product.
- Worked on the container building feature of the Open Build Service using Dockerfiles.
- Supported the community on public channels and provided solutions.
- Supported sales engineers with onsite problems.
- Took over team lead and management responsibilities for nine months after my manager
  left.
- Participated in cross-company discussions representing my team on collaborative projects.

Technologies: Kubernetes, Docker, cri-o, Go, Bash, Linux, AWS, Azure, GKE.

I worked remotely full time from Greece. My team had members in at least three time zones,
with some people ten hours apart, and practised agile methodologies including planning
poker, retrospectives and TDD.

### Testributor

Co-founder and CTO
{: .cv-role}

October 2015 to December 2016
{: .cv-dates}

Together with three other co-founders I created Testributor, a continuous integration
platform built on a hybrid resource pool. Users could turn any available computing
resource, whether a data centre machine, a cloud instance or a workstation, into a build
worker, which maximised utilisation and reduced build times.

My role was to drive the design of the application and implement the core features. The
guiding idea was to make setting up a test environment easy and spawning workers as simple
as running a single command. The user selected the technologies the application needed and
the platform generated a docker-compose.yml file. Running that file started the containers,
the agent connected to the main server, pulled jobs, ran them and reported results back to
a central dashboard.

The agent was originally written in Ruby and used Redis for storage. It was later rewritten
in Go, which removed most external dependencies and made it easy to run on Windows and
macOS.

As a co-founder I took part in the business decisions, business plans and investor
negotiations. We applied to several accelerators and were selected for the StartupBootcamp
Istanbul programme, which we could not attend due to force majeure.

Technologies: Ruby, Ruby on Rails, Go, NodeJS, Socket.io, ReactJS, PostgreSQL, Redis,
Docker, Docker Compose, AWS, Heroku, Git.

### Incrediblue

Senior Developer
{: .cv-role}

March 2014 to October 2015
{: .cv-dates}

Worked on practically every part of the product:

- Enhanced the search capabilities of the platform.
- Created a content-based recommender for more personalised search.
- Created a distributed testing infrastructure to reduce the total running time of the test
  suite.
- Reviewed code from other developers.
- Upgraded the application from Rails 3 to Rails 4.

Technologies: Ruby on Rails 3.2 to 4.1, PostgreSQL, PostGIS, jQuery, Haml, SCSS,
CoffeeScript, AWS, Heroku, GitHub, MiniTest, Bootstrap.

I worked full time remotely and participated in all monthly company meetings. The team
practised agile methodologies including planning poker, retrospectives and TDD.

### Skroutz

Backend Developer
{: .cv-role}

October 2012 to March 2014
{: .cv-dates}

[skroutz.gr](https://www.skroutz.gr)
{: .cv-site}

The best known comparison shopping engine in Greece. My role was to extend the backend
application with new features and eliminate bugs. Among other responsibilities:

- Built a full CRM system used by company personnel, with an integrated issue tracking
  system for user support.
- Built a three-point API for data sharing between Skroutz instances (skroutz.gr and
  alve.com), with a separate application managing the data interchange, a translation
  memory system and a callback mechanism that made the translation process transparent to
  end users.
- Added authorisation capabilities to the existing backend application.

Technologies: MongoDB with Mongoid, Elasticsearch, Redis, Resque, MySQL, Bootstrap, RSpec
and FactoryGirl.

I worked in house for the first year and remotely full time for the rest of my time on the
project.

### Xegesis

Developer
{: .cv-role}

October 2011 to October 2012
{: .cv-dates}

Xegesis generated articles for various sports automatically from numeric and other data. It
was built with Ruby on Rails 3 and MySQL. My roles were:

- Adding features and improving the performance of the backend application.
- Importing new data sources to enrich the generated content, for example weather during
  events.
- Developing the mobile version of the application.
- Writing unit and integration tests for both mobile and backend.
- Working with editors and translators on the application's special syntax.
- Creating maintenance scripts in Ruby and PHP.
- Participating in quality evaluation of the final product.

Deployment to AWS was handled by Capistrano. Tests were written with RSpec, Capybara and
QUnit, with Sinon.js for mocking. The mobile application was developed with PhoneGap and
jQuery Mobile, targeting Android and iPhone. The project was organised remotely, with
communication over VoIP and online project management tools.

### National Technical University of Athens

Thesis project
{: .cv-role}

2010
{: .cv-dates}

Developed an application that used GRID infrastructure to stream live video and audio to a
large number of viewers, dynamically allocating new resources. I built every part of it,
including the graphical control panel and the web interface for end users. The application
consisted of two multithreaded servers, a PHP feedback client and a desktop control panel.

It was developed entirely with free software. A Python server waited for new users to
connect and assigned the video stream to a GRID reflector. New reflectors could be spawned
from the GTK control panel, and a distributor streamed the video to the reflectors. End
users watched through a web page with the VLC plugin. The application was tested and
demonstrated live under realistic conditions.

Technologies: Python, PHP, HTML, GTK.

### Algosystems S.A.

Internship
{: .cv-role}

September to December 2005
{: .cv-dates}

Converted the data collecting server of a fleet management and tracking system from a
normal Windows application to a Windows service, so that it could run automatically after
restart and before user login. The application received data transmitted by GSM and GPRS
devices mounted on vehicles. Data was stored in MySQL and presented through a web page
built with PHP and Autodesk MapGuide. The service was written in Delphi and Pascal.

## Own projects

- **[voice-keyboard](https://github.com/jimmykarily/voice-keyboard).** A local audio
  transcription tool that acts as a voice keyboard on Linux and Wayland, written in Go.
  Everything runs on the machine, with no cloud service involved.
- **[sbom-extractor](https://github.com/jimmykarily/sbom-extractor).** A tool to extract
  SBOMs from OCI image attestations.
- **[kairosadm](https://github.com/jimmykarily/kairosadm).** A tool to manage a Kairos
  cluster without needing Kubernetes.
- **[Open OCR Reader](https://github.com/jimmykarily/open-ocr-reader).** Started as part of
  SUSE's Hackweek. The purpose is to let blind people read a regular book in the simplest
  way possible.
- **Local Agency of Land Reclamation.** The agency distributes water to local farms but had
  no effective way to manage billing data. Built with Ruby on Rails, using Google Maps to
  draw and store plots in a MySQL database.
- **Freelance.** Custom applications with PHP, CSS, Ajax and jQuery, websites with Drupal
  6.x and 7.x, and portable desktop applications with Python, TKinter or GTK and SQLite.

## Education

**March 2011.** Graduated from the School of Applied Mathematical and Physical Sciences,
National Technical University of Athens.

**November 2006.** Two day seminar organised by the Greek Research and Technology Network
on Advanced Issues in Grid Technologies.

## Publications

Dimitris Karakasilis, Fotis Georgatos, Lambros Lambrinos, Theodoros Alexopoulos,
"Application of Live Video Streaming over GRID and Cloud infrastructures", 11th IEEE
International Conference on Computer and Information Technology, 2011, Cyprus, Conference
Proceedings.

<p class="cv-updated" markdown="0">EU citizen, based in Greece. Working remotely since 2012. Last updated {{ page.updated | date: "%B %Y" }}.</p>

</div>
