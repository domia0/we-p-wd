import {modalSignIn}     from './_modal-sign-in'
import {modalSignUp}     from './_modal-sign-up'
import {likesForMemes}   from './_likes-for-memes'
import {modalComments}   from './_modal-comments'
import {reportsForMemes} from './_reports-for-memes'

$(document).ready(function () {
  // Step 1
  // (Sign-in/up)
  modalSignIn();
  modalSignUp();
  // Step 2
  // (Likes for memes)
  likesForMemes();
  // Step 3
  // (Comments for memes)
  modalComments();
  // Step 4
  // (Reports for memes)
  reportsForMemes();
});