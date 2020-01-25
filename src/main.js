import { Elm } from "./elm/Main.elm"
import firebase from "firebase/app"
import "firebase/auth"

// =============================================================================
// > Elm
// =============================================================================

const elmApp = Elm.Main.init({
  node: document.getElementById("main"),
  flags: null,
})

// =============================================================================
// > Firebase
// =============================================================================

firebase.initializeApp({
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  databaseURL: process.env.FIREBASE_DATABASE_URL,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID,
})

// > Authentication ------------------------------------------------------------

const authSignUp = async (email, password) => {
  try {
    await firebase.auth().createUserWithEmailAndPassword(email, password)
  } catch (error) {
    return {
      type: "SIGN_UP_ERROR",
      errorCode: error.code,
    }
  }
  return null
}

const authSignIn = async (email, password) => {
  try {
    await firebase.auth().signInWithEmailAndPassword(email, password)
  } catch (error) {
    return {
      type: "SIGN_IN_ERROR",
      errorCode: error.code,
    }
  }
  return null
}

const authSignOut = async () => {
  await firebase.auth().signOut()
  return null
}

const authStateChanged = user => {
  if (user) {
    return {
      type: "LOGGED_IN",
      email: user.email,
      uid: user.uid,
    }
  } else {
    return {
      type: "LOGGED_OUT",
    }
  }
}

const authReduce = async action => {
  switch (action.type) {
    case "SIGN_UP":
      return authSignUp(action.email, action.password)
    case "SIGN_IN":
      return authSignIn(action.email, action.password)
    case "SIGN_OUT":
      return authSignOut()
    case "AUTH_CHANGED":
      return authStateChanged(action.user)
  }
}

const authUpdate = async action => {
  const result = await authReduce(action)
  console.log(action.type)
  if (result !== null) {
    console.log(result)
    elmApp.ports.authFromJs.send(result)
  }
}

const authStartup = () => {
  elmApp.ports.authToJs.subscribe(action => authUpdate(action))
  firebase
    .auth()
    .onAuthStateChanged(user => authUpdate({ type: "AUTH_CHANGED", user }))
}

authStartup()
