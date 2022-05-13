import axios from 'axios';

export default axios.create({
  baseURL: process.env.APP_DOMAIN || 'http://localhost:3000',
  // headers: {
  //   Authorization: 'Bearer {token}'
  // }
})