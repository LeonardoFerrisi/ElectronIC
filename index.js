// Node Starter client script
// Author:  Leonardo Ferrisi
// Contact: Leonardo.Ferrisi@utah.edu

const axios = require('axios');
const net = require('net');

// Helper function to send a command to the MATLAB server
async function sendCommandToMATLAB(command) {
  const client = new net.Socket();

  return new Promise((resolve, reject) => {
    client.connect(3000, '127.0.0.1', () => {
      console.log('Connected to MATLAB server');
      client.write(command + '\n');
    });

    client.on('data', (data) => {
      console.log('Received response from MATLAB server:', data.toString());
      resolve(data.toString());
      client.destroy(); // Close the connection
    });

    client.on('error', (err) => {
      console.error('Error connecting to MATLAB server:', err.message);
      reject(err);
    });
  });
}

// Example usage
(async () => {
  try {

    // An example: Command gets evaluated on matlab side and response is returned through the const `response`
    //   This can be utilized as values that are returned to the user
    //      TODO: Review the efficacy of doing this with bytecode for images...
    const response = await sendCommandToMATLAB('2+2');
    console.log('Response from MATLAB:', response);
  } catch (error) {
    console.error('Error:', error);
  }
})();
