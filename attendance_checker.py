import json
import csv
from datetime import datetime


def load_config():
    with open('Helpers/config.json', 'r') as f:
        return json.load(f)


def check_attendance():
    config = load_config()
    warning_threshold = config.get('warning_threshold', 75)
    failure_threshold = config.get('failure_threshold', 50)

    results = []

    with open('Helpers/assets.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            attended = int(row['attended'])
            total = int(row['total'])
            if total > 0:
                percentage = (attended / total) * 100
            else:
                percentage = 0

            if percentage < failure_threshold:
                status = "FAIL"
            elif percentage < warning_threshold:
                status = "WARNING"
            else:
                status = "PASS"

            results.append({
                'id': row['student_id'],
                'name': row['name'],
                'percentage': percentage,
                'status': status
            })

    return results


def log_results(results):
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open('reports/reports.log', 'a') as f:
        f.write(f"\n=== Report: {timestamp} ===\n")
        for r in results:
            f.write(f"{r['id']} | {r['name']} | {r['percentage']:.1f}% | {r['status']}\n")


if __name__ == '__main__':
    results = check_attendance()
    print(f"{'ID':<6} {'Name':<16} {'Attendance':>10} {'Status':>8}")
    print("-" * 44)
    for r in results:
        print(f"{r['id']:<6} {r['name']:<16} {r['percentage']:>9.1f}% {r['status']:>8}")
    log_results(results)
    print("\nResults saved to reports/reports.log")
