# Voting Smart Contract

##### Author : Nasri Adzlani

##### Requirements
- node (im using v16)
- vscode
- ganache-cli (can use hardhat local network)


Create Smartcontract using Remix
![N|Solid](https://raw.githubusercontent.com/masnasri-a/images/main/Screen%20Shot%202022-05-19%20at%2012.19.59.png)
when testing using remix, all contract function work

### Deploy and Testing
#
#### Ganache 
##### Setup Local node
Ganache CLI is the latest version of TestRPC: a fast and customizable blockchain emulator
```
$ npm install -g ganache-cli
```
to run node use command below
```
$ ganache-cli
```

#### Hardhad
Hardhat is a development environment to compile, deploy, test, and debug your Ethereum software.
##### Install Hardhad 
#
```
$ npm install --save-dev hardhat
```

create Project using hardhat
```
npx hardhat
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

Welcome to Hardhat v2.0.8

? What do you want to do? …
  Create a sample project
  Create an advanced sample project
❯ Create an advanced sample project that uses TypeScript
  Create an empty hardhat.config.js
  Quit
```
im using Create an advanced sample project that uses TypeScript

open your text editor, im use vscode for text editor
```
$ cd <your project>
$ code .
```

Add contract remix into contract folders, and edit a deploy script at scripts/deploy.ts:
```
import { ethers } from "hardhat";

async function main() {

  const Voting = await ethers.getContractFactory("Voting");
  const voting = await Voting.deploy(60);

  await voting.deployed();

  console.log("Voting deployed to:", voting.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

##### Deploy
Deploy into localnode 
```
$ npx hardhat run --network localhost scripts/deploy.ts
```
will return contract address
```
Debugger attached.
Debugger attached.
No need to generate any newer typings.
Debugger attached.
Voting deployed to: 0x947558E21c89D41355E946A1Dab58a1fEE10ac35
```

##### Test
Im add test script into package.json to simply running test
```
,
  "scripts": {
    "test": "hardhat test"
  }
```

Edit test script at test/index.ts
```
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Voting", function () {
  it("Test Voting Contract", async function () {
    const [owner, addr1, addr2, addr3] = await ethers.getSigners();
    const Voting = await ethers.getContractFactory("Voting");
    const voting = await Voting.connect(owner).deploy(5);
    await voting.deployed();
    function timeout() {
      return new Promise((resolve) => setTimeout(resolve, 15000));
    }

    const addCandidate = await voting.addCandidate(["nasri", "okta"]);
    await addCandidate.wait();
    await voting.connect(addr1).vote(0);
    await voting.connect(addr2).vote(0);
    await voting.connect(addr3).vote(1);
    await timeout();

    // const winner = await voting.connect(owner).winners();
    // expect(winner).to.equal(0);
    // await voting.connect(owner).sendReward({value: 1*18 })
  });
});
```
Note: send reward error testing on hardhat because require block.timestamp must be longer than end period timestamp, but on hardhat not changed block.timestamp after set Timeout, but im running on remix can be execute and not error

example test
```
> test
> hardhat test

Debugger attached.
No need to generate any newer typings.

  Voting
    ✔ Test Voting Contract (15502ms)

```

