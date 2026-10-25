import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (!admin.apps.length) {
    admin.initializeApp();
}

export const handleVoteCount = functions.firestore
  .document("posts/{postId}/votes/{userId}")
  .onWrite(async (change, context) => {
    const postId = context.params.postId;
    const postRef = admin.firestore().collection("posts").doc(postId);

    const beforeData = change.before.exists ? change.before.data() : null;
    const afterData = change.after.exists ? change.after.data() : null;

    const beforeVote = beforeData ? beforeData.vote : null;
    const afterVote = afterData ? afterData.vote : null;

    if (beforeVote === afterVote) return null;

    let upvoteChange = 0;
    let downvoteChange = 0;

    if (beforeVote === 'up') upvoteChange -= 1;
    if (beforeVote === 'down') downvoteChange -= 1;

    if (afterVote === 'up') upvoteChange += 1;
    if (afterVote === 'down') downvoteChange += 1;

    return postRef.update({
      upvotes: admin.firestore.FieldValue.increment(upvoteChange),
      downvotes: admin.firestore.FieldValue.increment(downvoteChange)
    });
  });
