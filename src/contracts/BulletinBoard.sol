pragma solidity ^0.5.0;

contract BulletinBoard {
    struct Comment {
        uint timestamp;
        uint bulletinID;
        uint commentID;
        string commentator;
        string content;
        address from;
    }

    struct Bulletin {
        uint timestamp;
        uint bulletinID;
        string announcer;
        string title;
        string content;
        address from;   // Address of the Bulletin owner (Account)
    }

    uint private FreeBulletinID;    // We don't consider concurrently access for FreeBulletinID and FreeCommentID.
    uint private FreeCommentID;
    Bulletin[] private Bulletins;
    Comment[] private Comments;

    constructor() public {
        FreeBulletinID = 1;
        FreeCommentID = 1;
    }

    function publishBulletin(string memory a, string memory t, string memory c) public returns (uint) {
        Bulletin memory bulletin = Bulletin({
            timestamp: now,
            bulletinID: FreeBulletinID,
            announcer: a,
            title: t,
            content: c,
            from: msg.sender
        });
        Bulletins.push(bulletin);
        FreeBulletinID++;

        return bulletin.bulletinID;
    }

    function getBulletinByID(uint id) public view returns (uint, uint, string memory, string memory, string memory, address) {
        uint Length = Bulletins.length;
        for (uint i = 0; i < Length; ++i) {
            Bulletin memory bulletin = Bulletins[i];
            if (bulletin.bulletinID == id) {
                return (bulletin.bulletinID, bulletin.timestamp, bulletin.announcer, bulletin.title, bulletin.content, bulletin.from);
            }
        }

        return (id, 0, "", "", "", msg.sender);
    }

    function publishComment(uint bulletin_id, string memory cmtr, string memory ctnt) public returns (uint, uint) {
        if (bulletin_id >= FreeBulletinID) {
            return (bulletin_id, 0);
        }

        Comment memory comment = Comment({
            timestamp: now,
            bulletinID: bulletin_id,
            commentID: FreeCommentID,
            commentator: cmtr,
            content: ctnt,
            from: msg.sender
        });
        Comments.push(comment);
        FreeCommentID++;

        return (comment.bulletinID, comment.commentID);
    }

    function getCommentByID(uint id) public view returns (uint, uint, uint, string memory, string memory, address) {
        uint Length = Comments.length;
        for (uint i = 0; i < Length; ++i) {
            Comment memory comment = Comments[i];
            if (comment.commentID == id) {
                return (comment.bulletinID, comment.commentID, comment.timestamp, comment.commentator, comment.content, comment.from);
            }
        }

        return (0, id, 0, "", "", msg.sender);
    }
/*
    function getCommentsByBulletinID(uint bid) public view returns (Comment[] memory) {
        Comment[] memory comments;
        uint Length = Comments.length;
        for (uint i = 0; i < Length; ++i) {
            Comment memory comment = Comments[i];
            if (comment.bulletinID == bid) {
                comments.push(comment);
            }
        }

        return comments;
    }
*/
}