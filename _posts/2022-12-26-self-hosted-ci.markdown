---
layout: default
title: "Self Hosted CI"
description: Because avoiding vendor lock-in doesn't have to be hard.
date:   2022-12-26
tags: [kubernetes, woodpecker, drone, CI, codeberg, gitea]
---

# Self hosted CI

## Why

Don't you enjoy how everything is for free these days? You host your code for free, you get [a free CI with computing resources for free](https://github.com/features/actions).
And you [don't even need an IDE or a workstation](https://github.com/features/codespaces). Everybody loves free things. But as someone said, "if you don't pay for the product, you are the product". Is that really true in every case? I don't know. What I do know though, is that it happened in the past, that we became [too used to free services and then one day everything changed](https://www.theregister.com/2021/08/31/docker_desktop_no_longer_free/) and we had to look for alternatives. And alternatives we found, that's true. But we have to learn our lesson. We need to be prepared or even better, not fall in, what I call, the "convenience trap" at all.

## What

Drop convenience you said Dimitris? What do you suggest? That we start hosting everything ourselves?

No my dear friend, that's not what I'm suggesting. Thankfully, there are [less suspicious free services](https://docs.codeberg.org/getting-started/what-is-codeberg/#what-is-codeberg-e.v.%3F) that we can use as long as we are ready to make some changes.

What I found is that for some of the most popular services that people use nowadays, there is a free/opensource/non-profit alternative that could be used. But sometimes, it misses some features, or it's simply different from what people are used to. Some examples:

- [Twitter](https://twitter.com/) -> [Mastodon](https://mastodon.social)
- [GitHub](https://github.com/) -> [Codeberg](https://codeberg.org/) / [Gitea](https://gitea.io/)
- Windows -> Linux

and the list goes on...

This post is about the solution I found for one of the missing features while trying to switch from [Github](https://github.com/) to [Codeberg](https://codeberg.org/). And that feature is CI (GitHub offers Github Actions for free [1]).

## How

CI is a very special kind of a service. It:

- is needed in almost every project (you do write tests, right?)
- sometimes needs lots of resources
- has to be publicly available (to see test results)
- has to integrate with the Code hosting service (Github, Codeberg etc)

yet it:

- is idling for a large portion of the time
- doesn't need to store information for too long (old build logs quickly become irrelevant)
- has configuration usually stored next to the code, at least the important parts (e.g. pipelines)

So let's say you have 10 or 100 projects, which all have tests and have CI needs. But you don't work on all of them all the time. Even if you were willing to go into the trouble of setting up your own CI server, would you keep it running all the time just for those weekends when you find time to work on that Arduino powered lunar rover you are working on?
Cloud resources are expensive. Local resources on the other hand are not.

Here is my suggestion. What if you could host the CI on your own machine, yet make it available online whenever it's needed with minimum cost?
I created a repository that will help you do exactly that:

[https://codeberg.org/dkarakasilis/self-hosted-ci](https://codeberg.org/dkarakasilis/self-hosted-ci)

In a nutshell, this is how it works:

- You get yourself the smallest public machine possible. I chose the smallest Digital Ocean droplet for 4 dollars per month but you can choose something else, as long as it has a public IP address and you have SSH access to it.
- You point your desired domain to that machine. In other words you create an A record on your nameserver, pointing your domain to the IP address of the above machine.
- You start a Kubernetes cluster anywhere you like. I just run `k3d cluster create myci` but there is a really large number of options [2].
- You deploy cert-manager using helm (this is needed in order to have a properly signed letsencrypt certificate for the CI server).
- You use my helm chart to deploy [Woodpecker CI](https://woodpecker-ci.org/) and the nginx-ssh-proxy component.

Done!

Probably the part that may not be completely clear is the `nginx-ssh-proxy`. This is just a Kubernetes Deployment that does 2 things:

- creates an SSH tunnel to the public machine to forward ports 80 and 443 to the Pod's local ports 80 and 443
- runs an nginx reverse proxy that forwards the ports 80 and 443 to the same ports of the Traefik Ingress controller, running on the cluster

In other words, any request reaching ports 80/443 of the public machine, will eventually hit the traefik ingress controller, thus all ingresses on the cluster will work as if we had made the cluster publicly available.

The benefits:

- We don't need to have the whole cluster hosted on the cloud (less costly)
- We didn't have to forward any ports or change any local network configuration
- The cluster could be replaced with another one with zero changes in configuration

The drawbacks:

- There can be a combination of security holes that may allow someone to escape the HTTP protocol, into the Pod, from there into the Node and from there to the host machine and possibly attack other machines on your local network. While this is possible, it depends on your setup and it takes more than one security hole in more than one projects to allow someone to do that. Check my suggestion on the project README about using [Kairos](https://kairos.io) as a better and more secure alternative to k3d.
- Your CI will only be available for as long as you keep the cluster up and running. When your CI is gone, Codeberg won't be able to reach it and obviously won't be able to start any jobs on it.
- You need to take care of CI configuration yourself (e.g. what values to pass through the helm chart when deploying). But that's why I called the alternative "the convenience trap".

## Conclusion

I hope this post shows that it's possible and even maybe easy to bypass some of the problems you face when you decide to free yourself from vendor lock-in.
If not, then I'd like to hear your thoughts so don't hesitate to reach out. If you have suggestions on how to improve this solution feel free to open an issue or a Pull Request!

Have fun!

[1] [The codeberg team has a hosted service in the works](https://codeberg.org/Codeberg-CI). But this article is about avoiding vendor lock-in. In that sense, it will still apply when that service is open to everyone. 

[2] For now, the helm chart assumes this cluster is running the [traefik ingress controller](https://doc.traefik.io/traefik/providers/kubernetes-ingress/) but this may become configurable on the helm chart in the future.
