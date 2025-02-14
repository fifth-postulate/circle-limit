# Circle Limit
An [hyperbolic plane][wikipedia:hyperbolic-geometry] exploration of [Functional Geometry][paper:functional-geometry].

## Origin Story
At [Booster Conf 2023][conference:booster.2023] [Einar W. Høst][bluesky:einarwh] presented the workshop [_The Escher school of Fish_][github:einarwh.workshop].

This workshop presents the ideas of Peter Hendersons [revised 2002 paper][paper:functional-geometry] _Functional Geometry_ by guiding participants through a JavaScript implementation.

During the Q&A it was mentioned that [_Circle Limit III_][wikipedia:circle-limit-III], another work by Escher, is not as easily adapted to the same drawing primitives.

[![Circle Limit III; Art on the hyperbolic plane](https://upload.wikimedia.org/wikipedia/en/thumb/5/55/Escher_Circle_Limit_III.jpg/290px-Escher_Circle_Limit_III.jpg)][wikipedia:circle-limit-III]

I interjected that the ideas are still applicable, only that the underlying geometry is different.

After a quick consultation, we agreed to challenge ourselves and try to apply Hendersons ideas and create a workshop to reproduce Circle Limit III. 

## Goal
The goal of this project is

> A workshop where participants recreate Eschers Circle Limit III by applying the ideas of Functional Geometry to the hyperbolic plane.

In goals of the workshop itself should include

* **Having fun**: enjoying yourself is a great motivator and fascilitates creating an environment where learning is easier.
* **Learning about Functional Geometry**: the ideas presented in Functional Geometry are more widely applicable then just for creating complex pictures. Understanding these concepts allow people to apply them in different scenarios.
* **Exploring the hyperbolic plane**: [hyperbolic geometry][wikipedia:hyperbolic-geometry] is the lesser know cousin to [Euclidean geometry][wikipedia:euclidean-geometry]; the geometry of the plane, where lines and circles live. Exploring the similarities and difference of these geometries is a exciting oppertunity.

## Explorations
Although the goal is clear, the means to reach it aren't as clear. Ideas, thoughts, explorations and experiments are needed before fleshing out the actual workshop.

### TiddlyWiki
In order to document these activities the [Circle Limit TiddlyWiki][documentation:tiddlywiki] is created. A [TiddlyWiki][tiddlywiki] is a

> unique non-linear notebook for capturing, organising and sharing complex information.

### Prototypes
Code can be a vehicle of thought, so creating [prototypes][directory:prototype] is a great way to better understand various aspects of hyperbolic geometry.

![Prototype of Hyperbolic Tiling](https://fifth-postulate.nl/circle-limit/image/dunham-tiling.2023-05-11.png)

### Development
We use Make to automate various tasks in this project. Run 

```plain
make
```

To kick things off.

[conference:booster.2023]: https://2023.boosterconf.no/
[directory:prototype]: https://github.com/fifth-postulate/circle-limit/tree/main/prototype
[documentation:tiddlywiki]: https://fifth-postulate.nl/circle-limit/index.html
[github:einarwh.workshop]: https://github.com/einarwh/escher-workshop-js
[paper:functional-geometry]: https://eprints.soton.ac.uk/257577/1/funcgeo2.pdf
[tiddlywiki]: https://tiddlywiki.com/
[bluesky:einarwh]: https://bsky.app/profile/einarwh.bsky.social
[wikipedia:circle-limit-III]: https://en.wikipedia.org/wiki/Circle_Limit_III
[wikipedia:euclidean-geometry]: https://en.wikipedia.org/wiki/Euclidean_geometry
[wikipedia:hyperbolic-geometry]: https://en.wikipedia.org/wiki/Hyperbolic_geometry
