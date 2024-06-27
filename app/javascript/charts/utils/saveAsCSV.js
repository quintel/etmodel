/**
 * Event handler for downloading chart data as CSV.
 * @param {MouseEvent} event - The click event.
 * @param {string} chartId - The ID of the chart to fetch data for.
 */
const onDownloadCSVClick = async (event, chartId) => {
    event.preventDefault();
    console.log('Downloading CSV for chart:', chartId);

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
    } catch (error) {
      console.error('There was a problem with the fetch operation:', error);
    }
  };

  // Add event listener to the CSV download button
  document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM fully loaded and parsed');
    document.querySelectorAll('.chart_to_csv').forEach(button => {
    console.log('Adding event listener to button');
      button.addEventListener('click', (event) => {
        const chartHolder = event.target.closest('.chart_holder');
        const chartId = chartHolder.getAttribute('data-holder_id');
        onDownloadCSVClick(event, chartId);
      });
    });
  });
