import axios from 'axios';

export default axios.create({
  baseURL: process.env.APP_DOMAIN || 'http://localhost:3000',
  headers: {
    'Cache-Control': 'no-cache, no-store, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0'
  }
})