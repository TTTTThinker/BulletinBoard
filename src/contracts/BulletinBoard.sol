pragma solidity ^0.5.0;

contract BulletinBoard {
    struct User {
        uint userID;
        uint registerTime;
        string userName;
        uint passwordHash;
    }

    struct Comment {
        uint timestamp;
        uint userID;
        uint bulletinID;
        uint commentID;
        string content;
        address from;
    }

    struct Bulletin {
        uint timestamp;
        uint userID;
        uint bulletinID;
        string title;
        string content;
        address from;   // Address of the Bulletin owner (Account)
    }

    uint private FreeUserID;
    uint private FreeBulletinID;    // We don't consider concurrently access for FreeUserID, FreeBulletinID and FreeCommentID.
    uint private FreeCommentID;
    User[] private Users;
    Bulletin[] private Bulletins;
    Comment[] private Comments;

    constructor() public {
        FreeUserID = 1;
        FreeBulletinID = 1;
        FreeCommentID = 1;
    }

    function registerUser(string memory name, string memory passwd) public returns (uint) {
        User memory user = User({
            userID: FreeUserID,
            registerTime: now,
            userName: name,
            passwordHash: uint(keccak256(abi.encodePacked(passwd)))
        });
        Users.push(user);
        FreeUserID++;

        return user.userID;
    }

    function getUserByID(uint uid, string memory passwd) public view returns (uint, string memory) {
        if (uid > Users.length) {
            return (0, "");
        }

        User memory user = Users[uid - 1];
        if (uint(keccak256(abi.encodePacked(passwd))) != user.passwordHash) {
            return (0, "");
        }

        return (user.registerTime, user.userName);
    }

    function publishBulletin(uint uid, string memory passwd, string memory t, string memory c) public returns (uint) {
        if (uid > Users.length) {
            return 0;
        }

        User memory user = Users[uid - 1];
        if (uint(keccak256(abi.encodePacked(passwd))) != user.passwordHash) {
            return 0;
        }

        Bulletin memory bulletin = Bulletin({
            timestamp: now,
            userID: user.userID,
            bulletinID: FreeBulletinID,
            title: t,
            content: c,
            from: msg.sender
        });
        Bulletins.push(bulletin);
        FreeBulletinID++;

        return bulletin.bulletinID;
    }

    function getBulletinByID(uint bid) public view returns (uint, uint, uint, string memory, string memory, address) {
        uint Length = Bulletins.length;
        for (uint i = 0; i < Length; ++i) {
            Bulletin memory bulletin = Bulletins[i];
            if (bulletin.bulletinID == bid) {
                return (bulletin.userID, bulletin.bulletinID, bulletin.timestamp, bulletin.title, bulletin.content, bulletin.from);
            }
        }

        return (0, 0, 0, "", "", msg.sender);
    }

    function publishComment(uint uid, string memory passwd, uint bulletin_id, string memory ctnt) public returns (uint) {
        if (uid > Users.length) {
            return 0;
        }

        User memory user = Users[uid - 1];
        if (uint(keccak256(abi.encodePacked(passwd))) != user.passwordHash) {
            return 0;
        }

        if (bulletin_id >= FreeBulletinID) {
            return 0;
        }

        Comment memory comment = Comment({
            timestamp: now,
            userID: uid,
            bulletinID: bulletin_id,
            commentID: FreeCommentID,
            content: ctnt,
            from: msg.sender
        });
        Comments.push(comment);
        FreeCommentID++;

        return comment.commentID;
    }

    function getCommentByID(uint cid) public view returns (uint, uint, uint, uint, string memory, address) {
        uint Length = Comments.length;
        for (uint i = 0; i < Length; ++i) {
            Comment memory comment = Comments[i];
            if (comment.commentID == cid) {
                return (comment.userID, comment.bulletinID, comment.commentID, comment.timestamp, comment.content, comment.from);
            }
        }

        return (0, 0, 0, 0, "", msg.sender);
    }
}