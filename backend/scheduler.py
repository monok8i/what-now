"""
Task scheduler for downloading datasets from external sources.

This script runs scheduled tasks to download CSV files from:
- ČSSZ (Czech Social Security Administration)
- NKOD (National Catalog of Open Data)
- RPSS (Register of Social Service Providers) - full sync with database

Schedule: Daily at 3:00 AM
"""

import logging
import sys
from pathlib import Path

from apscheduler.schedulers.blocking import BlockingScheduler  # type: ignore
from apscheduler.triggers.cron import CronTrigger  # type: ignore

from src.infra.external_api.parse import cssz, nkod
from src.infra.external_api.parse.rpss_sync import run_full_sync as rpss_sync

# Add backend directory to path
backend_dir = Path(__file__).parent
sys.path.insert(0, str(backend_dir))


# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)

logger = logging.getLogger(__name__)


def run_cssz_download():
    """Download datasets from ČSSZ."""
    try:
        logger.info("Starting ČSSZ dataset download...")
        datasets = cssz.find_datasets()
        logger.info(f"Found {len(datasets)} ČSSZ datasets")

        for dataset in datasets:
            try:
                cssz.download_file(dataset["url"])
            except Exception as e:
                logger.error(f"Failed to download {dataset['url']}: {e}")

        logger.info("ČSSZ download completed")
    except Exception as e:
        logger.error(f"ČSSZ download task failed: {e}")


def run_nkod_download():
    """Download datasets from NKOD."""
    try:
        logger.info("Starting NKOD dataset download...")
        datasets = nkod.find_datasets()
        logger.info(f"Found {len(datasets)} NKOD datasets")

        for dataset in datasets:
            try:
                nkod.download_file(dataset["url"])
            except Exception as e:
                logger.error(f"Failed to download {dataset['url']}: {e}")

        logger.info("NKOD download completed")
    except Exception as e:
        logger.error(f"NKOD download task failed: {e}")


def run_rpss_sync():
    """Synchronize RPSS data (download, process, load to DB)."""
    try:
        logger.info("Starting RPSS data synchronization...")
        import asyncio

        asyncio.run(rpss_sync(cleanup=True))
        logger.info("RPSS synchronization completed")
    except Exception as e:
        logger.error(f"RPSS synchronization failed: {e}")
        import traceback

        logger.error(traceback.format_exc())


def run_all_downloads():
    """Run all download tasks sequentially."""
    logger.info("=" * 60)
    logger.info("Starting scheduled dataset downloads")
    logger.info("=" * 60)

    run_cssz_download()
    run_nkod_download()
    run_rpss_sync()

    logger.info("=" * 60)
    logger.info("All downloads completed")
    logger.info("=" * 60)


def main():
    """Main function to start the scheduler."""
    logger.info("🕐 Dataset Download Scheduler starting...")
    logger.info(f"📁 ČSSZ download directory: {cssz.DOWNLOAD_DIR}")
    logger.info(f"📁 NKOD download directory: {nkod.DOWNLOAD_DIR}")

    scheduler = BlockingScheduler()

    # Schedule daily downloads at 3:00 AM
    scheduler.add_job(  # type: ignore
        run_all_downloads,
        trigger=CronTrigger(hour=3, minute=0),
        id="daily_dataset_download",
        name="Daily Dataset Download",
        replace_existing=True,
    )

    logger.info("⏰ Scheduled daily downloads at 3:00 AM")

    # Run immediately on startup
    logger.info("🚀 Running initial download on startup...")
    run_all_downloads()

    try:
        logger.info("✅ Scheduler started. Press Ctrl+C to exit.")
        scheduler.start()  # type: ignore
    except (KeyboardInterrupt, SystemExit):
        logger.info("🛑 Scheduler stopped")


if __name__ == "__main__":
    main()
