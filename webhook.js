#!env node

// All scripts should do the pull themselves
var http = require('http');
var url  = require('url');
var exec = require('child_process').exec;
var gitPull = 'git pull';
var port = 2047;

var hmac = function (str) {
    var secret = process.env['secret'];
    var crypto = require('crypto');
    var hmac = crypto.createHmac('sha1', secret);
    hmac.update('some data to hash');
    return hmac.digest('hex');
};

var res200 = function(req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain' });
    res.end();
};

var resError = function(code, msg, req, res) {
    res.writeHead(code, {"Content-Type": "text/plain"});
    res.end(msg);
};

var pull = function (req, res) {
    runTask('./scripts/pull.sh', req, res);
};

var docs = function (req, res) {
    runTask('./doc/make.sh', req, res);
};

var rels = function (req, res) {
    runTask('./scripts/release.sh', req, res);
};

var runTask = function (script, req, res) {
    exec(script, function(error, stdout, stderr) {
        if (!error) {
            console.log(script + "\n" + stdout);
            res200(req, res);
        } else {
            resError(500, 'Internal Server Error\n', req, res);
            console.log("There was an error running pull\n" + error.stack);
            console.log(stderr);
        }
    });
};

var routes = {
    '/pull': pull,
    '/docs': docs,
    '/rels': rels
};

function tryPull (req, res) {
    //fixme -- verify by calculating hmac

    if (routes[url.parse(req.url).pathname]) {
       routes[url.parse(req.url).pathname](req, res);
    } else {
        resError(404, "404 Not Found\n", req, res);
    }
}

http.createServer(tryPull).listen(port, console.log("server listening at " + port));
