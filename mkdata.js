/**
 * Generates readme.json.
 */

'use strict'

const fs = require('fs')
    , path = require('path')
    , cp = require('child_process')

cp.exec(process.argv[0] + ' ' + path.resolve(__dirname, 'ned') + ' --help', {
  stdio: ['ignore', 'pipe', 'ignore']
}, (err, stdout) => {
  if (err) throw err
  fs.writeFileSync(path.resolve(__dirname, 'readme.json'), JSON.stringify({
    usage: stdout
  }))
})