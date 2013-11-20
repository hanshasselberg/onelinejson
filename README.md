# Onelinejson

Onelinejson gives you one line Rails logs. The only thing you need to do is specifying the gem in your Gemfile!

```json
{
  "debug_info": {},
  "response": {
    "view": 0.8,
    "duration": 79.43,
    "status": 200
  },
  "request": {
    "uuid": "47e4a7fa-7e8e-430b-b66a-1509f6e6da5a",
    "path": "/tasks/1",
    "action": "show",
    "controller": "tasks",
    "date": "2013-11-19T15:05:05Z",
    "format": "*/*",
    "headers": {
      "HTTP_VERSION": "HTTP/1.1",
      "HTTP_ACCEPT": "*/*",
      "HTTP_HOST": "localhost:3000",
      "HTTP_USER_AGENT": "curl/7.30.0"
    },
    "ip": "127.0.0.1",
    "method": "GET",
    "params": {
      "id": "1"
    }
  }
}
```

It has the following top level entries: `request`, `response` and `debug_info`. `request` contains `params`, `headers` and the usual stuff. `response` contains the status code and runtimes. `debug_info` is the place where you can put in stuff temporarily and use it for debugging.

## Installation

Add this line to your application's Gemfile:

    gem "lograge", git: "git@github.com:i0rek/lograge.git", branch: "before_format"
    gem 'onelinejson'

You need my lograge repo for now, until my PR got merged which I hope will happen eventually.
And then execute:

    $ bundle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
