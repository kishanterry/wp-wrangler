require('dotenv').config()

const fs = require('fs')
const NodeSSH = require('node-ssh').NodeSSH
const ssh = new NodeSSH()

const DW_DB_COMMAND = `ssh -p${process.env.REMOTE_SSH_PORT} ${process.env.REMOTE_USER}@${process.env.REMOTE_HOST} "mysqldump -u ${process.env.REMOTE_DB_USER} -p ${process.env.REMOTE_DB_PASSWORD} ${process.env.REMOTE_DB_DATABASE}"`

// var e = exec("ls -lah", (error, stdout, stderr) => {
//     console.log(stdout)
// })

async function downloadWordpress() {
    await sshConnect()
    let remote_data_dump = await downloadRemoteDatabase()
    let saved = await saveDataDumpFromRemote(remote_data_dump)    

    console.log(saved)
}

function downloadRemoteDatabase() {
    ssh.execCommand('ls -lah').then((result) => {
        return result.stdout
    })
    // return executeShellCommand(DW_DB_COMMAND)
}

function saveDataDumpFromRemote(sql_content) {
    file_name = `${process.env.REMOTE_DB_DATABASE}.sql`

    return fs.promises.writeFile(
        file_name,
        sql_content
    )
}

function sshConnect() {
    return ssh.connect({
        host: process.env.REMOTE_HOST,
        port: process.env.REMOTE_SSH_PORT,
        username: process.env.REMOTE_USER,
        privateKey: process.env.REMOTE_SSH_PRIVATE_KEY
    })
}

downloadWordpress()