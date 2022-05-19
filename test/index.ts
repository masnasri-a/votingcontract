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
