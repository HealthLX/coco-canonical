import pytest
from pathlib import Path

@pytest.fixture
def project_root():
    return Path(__file__).parent.parent

@pytest.fixture
def schemas_dir(project_root):
    return project_root / "schemas"

@pytest.fixture
def samples_dir(project_root):
    return project_root / "samples"