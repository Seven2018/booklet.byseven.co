const toggleShowBranchTree = () => {
  const chevrons = document.querySelectorAll(".chevron-display-tree");
  chevrons.forEach((chevron) => {
    chevron.addEventListener('click', (event) => {
      const restToHide = event.currentTarget.parentNode.nextElementSibling;
      restToHide.classList.toggle("d-none");
      const chevron = event.currentTarget;
      chevron.classList.toggle("fa-chevron-down");
      chevron.classList.toggle("fa-chevron-right");
    });
  });
}

export { toggleShowBranchTree };
