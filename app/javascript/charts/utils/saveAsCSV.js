const onDownloadCSVClick = async (event, chartId) => {
  event.preventDefault();
  console.log('CSV download button clicked, initiating CSV download');
  console.log(`Chart ID: ${chartId}`);

  try {
    const response = await fetch(`/output_elements/${chartId}/data_csv`, {
      headers: {
        'Accept': 'text/csv'
      }
    });

    if (!response.ok) {
      throw new Error('Network response was not ok');
    }

    const blob = await response.blob();
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = `${chartId}.csv`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    console.log('CSV download initiated successfully');
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error);
  }
};

const attachEventListeners = () => {
  const buttons = document.querySelectorAll('.chart_to_csv');
  console.log(`Found ${buttons.length} buttons with class .chart_to_csv`);
  buttons.forEach(button => {
    if (!button.dataset.listenerAttached) {
      console.log('Adding event listener to CSV download button');
      button.addEventListener('click', (event) => {
        const chartHolder = event.target.closest('.chart_holder');
        if (chartHolder) {
          const chartId = chartHolder.getAttribute('data-chart_id'); // Use data-chart_id attribute
          console.log(`Chart holder element:`, chartHolder);
          console.log(`Retrieved chart ID: ${chartId}`);
          onDownloadCSVClick(event, chartId);
        } else {
          console.log('Chart holder not found');
        }
      });
      button.dataset.listenerAttached = 'true';
    }
  });
};

const observer = new MutationObserver((mutations) => {
  let chartAdded = false;
  mutations.forEach((mutation) => {
    if (mutation.addedNodes.length) {
      mutation.addedNodes.forEach((node) => {
        if (node.nodeType === Node.ELEMENT_NODE && node.matches('.chart_holder')) {
          chartAdded = true;
        }
      });
    }
  });
  if (chartAdded) {
    attachEventListeners();
  }
});

document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM fully loaded and parsed');
  attachEventListeners();
  observer.observe(document.body, {
    childList: true,
    subtree: true
  });
});
