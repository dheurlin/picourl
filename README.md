A dead simple url shortener.

To add a route, simply add it to the file `routes` in this directory, using the
following format:

```
short-url   https://full-url.com
```

When you go to `url-to-this-instance.com/short-url` you will be redirected to
the full url.

## Building and executing

```
stack build --fast --pedantic
```

then `stack run` or install using `stack install` and then run via `picourl-exe`

By default it will run on port 8080. To change this, run with an environment
variable: `PICOURL_PORT=1234 picourl-exe`
