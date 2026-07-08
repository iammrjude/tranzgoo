const services = [
  { id: 'airtime', name: 'Airtime', enabled: true },
  { id: 'data', name: 'Data', enabled: true },
  { id: 'airtime-to-cash', name: 'Airtime2Cash', enabled: true },
  { id: 'education', name: 'Education', enabled: true },
  { id: 'electricity', name: 'Electricity', enabled: true },
  { id: 'cable', name: 'Cable TV', enabled: true }
];

const airtimeNetworks = [
  { id: 'mtn', name: 'MTN' },
  { id: 'airtel', name: 'Airtel' },
  { id: 'glo', name: 'Glo' },
  { id: '9mobile', name: '9mobile' }
];

const dataPlans = [
  { id: 'mtn-1gb-30d', network: 'mtn', name: 'MTN 1GB - 30 days', amount: 350 },
  { id: 'mtn-2gb-30d', network: 'mtn', name: 'MTN 2GB - 30 days', amount: 700 },
  { id: 'airtel-1gb-30d', network: 'airtel', name: 'Airtel 1GB - 30 days', amount: 350 },
  { id: 'glo-2gb-30d', network: 'glo', name: 'Glo 2GB - 30 days', amount: 600 },
  { id: '9mobile-1gb-30d', network: '9mobile', name: '9mobile 1GB - 30 days', amount: 350 }
];

const cableProviders = [
  { id: 'dstv', name: 'DStv' },
  { id: 'gotv', name: 'GOtv' },
  { id: 'startimes', name: 'StarTimes' }
];

const cablePackages = [
  { id: 'dstv-padi', provider: 'dstv', name: 'DStv Padi', amount: 3600 },
  { id: 'dstv-yanga', provider: 'dstv', name: 'DStv Yanga', amount: 5100 },
  { id: 'gotv-jinja', provider: 'gotv', name: 'GOtv Jinja', amount: 2700 },
  { id: 'gotv-max', provider: 'gotv', name: 'GOtv Max', amount: 5700 },
  { id: 'startimes-basic', provider: 'startimes', name: 'StarTimes Basic', amount: 2200 }
];

const electricityProviders = [
  { id: 'ekedc', name: 'Eko Electric' },
  { id: 'ikedc', name: 'Ikeja Electric' },
  { id: 'aedc', name: 'Abuja Electric' },
  { id: 'phed', name: 'Port Harcourt Electric' }
];

const educationProducts = [
  { id: 'waec-result-checker', name: 'WAEC Result Checker', amount: 4500 },
  { id: 'neco-token', name: 'NECO Token', amount: 1200 },
  { id: 'jamb-efacility', name: 'JAMB e-Facility PIN', amount: 5500 }
];

function findById(items, id) {
  return items.find((item) => item.id === String(id || '').toLowerCase());
}

module.exports = {
  airtimeNetworks,
  cablePackages,
  cableProviders,
  dataPlans,
  educationProducts,
  electricityProviders,
  findById,
  services
};
