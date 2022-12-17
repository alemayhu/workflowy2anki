Unfortunately, this project is no longer maintained.

I have other priorities in my life and no longer have time to update this project. Email me at [alexander@alemayhu.com](mailto:alexander@alemayhu.com) if you'd like to reach me.

# WorkFlowy 2 Anki

[![Netlify Status](https://api.netlify.com/api/v1/badges/4d818752-c360-4ca5-afa4-567add475a7b/deploy-status)](https://app.netlify.com/sites/eloquent-lamport-a418b8/deploys)

This is tool a to let you convert your WorkFlowy outlines to Anki cards easily.

## Development

Please note that the Imba programming language v2 is currently in alpha so expect
to see things breaking when you try stuff. When that is said, see below on how
to actually run this :smile:

> I am assuming you have Node.js already installed, if not then see their website on how todo that https://nodejs.org/en/

First make sure you have the dependencies installed
```
yarn # npm run install
```

Then in another terminal run 

```
yarn dev
```

The previous command will continously build the project.

To actually see the app running you need to either visit the local url in a browser or launch the app with

```
yarn start
```

## License

Unless otherwise specified in the source:

[MIT](./LICENSE)

Copyright (c) 2020, Alexander Alemayhu

## Credits

This would be super hard if it were not for the following projects:

- [anki-apkg-export](https://github.com/repeat-space/anki-apkg-export)
- [FileSaver.js](https://github.com/eligrey/FileSaver.js/)
- [jszip](https://github.com/Stuk/jszip)
- [Imba](https://github.com/imba/imba)

See the [package.json](./package.json) file for anything I missed.
