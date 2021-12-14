pragma solidity ^0.5.0;

contract BulletinBoard {
    struct Bulletin {
        uint timestamp;
        string announcer;
        string title;
        string content;
        address from;   // Address of the Bulletin owner (Account)
    }

    Bulletin[] private Bulletins;

    function publishBulletin(uint ts, string memory a, string memory t, string memory c) public {
        Bulletins.push(Bulletin({
            timestamp: ts,
            announcer: a,
            title: t,
            content: c,
            from: msg.sender
        }));
    }

    function getBulletin(uint ts) public view returns (uint, string memory, string memory, string memory, address) {
        uint Length = Bulletins.length;
        for (uint i = 0; i < Length; ++i) {
            Bulletin memory bulletin = Bulletins[i];
            if (bulletin.timestamp == ts) {
                return (ts, bulletin.announcer, bulletin.title, bulletin.content, bulletin.from);
            }
        }

        return (ts, "", "", "", msg.sender);
    }
}