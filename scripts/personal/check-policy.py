#!/usr/bin/env python3
"""Fail closed on updates that remove the known independent-sync policy hooks."""
from pathlib import Path

checks = {
    'kmp/src/commonMain/kotlin/org/tasks/billing/LocalFeatures.kt': ['const val enabled = true'],
    'app/src/main/java/org/tasks/billing/Inventory.kt': ['get() = LocalFeatures.enabled || IS_GENERIC ||'],
    'composeApp/src/commonMain/kotlin/org/tasks/di/CoreModule.kt': ['get() = org.tasks.billing.LocalFeatures.enabled || hasTasksAccount || _hasSubscription.value'],
    'composeApp/src/commonMain/kotlin/org/tasks/sync/SyncRunner.kt': [
        'if (!org.tasks.billing.LocalFeatures.enabled && !hasTasksOrg && !subscriptionProvider.awaitVerification())',
        'val hasPro = org.tasks.billing.LocalFeatures.enabled || hasTasksOrg || subscriptionProvider.subscription.first() != null',
    ],
    'composeApp/build.gradle.kts': ['packageName = "tasks-personal"'],
    'app/build.gradle.kts': ['applicationIdSuffix = ".personal"'],
}
for filename, required in checks.items():
    content = Path(filename).read_text()
    for snippet in required:
        if snippet not in content:
            raise SystemExit(f'Policy changed in {filename}; review sync gates before building. Missing: {snippet}')
print('Known subscription-free policy hooks are intact. New upstream code still requires review.')
