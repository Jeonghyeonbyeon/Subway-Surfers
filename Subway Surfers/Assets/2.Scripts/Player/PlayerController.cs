using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private float playerSpeed;
    [SerializeField] private float playerJumpSpeed;
    [SerializeField] private LayerMask layerMask;
    private int playerPosition = 0;
    private Rigidbody playerRigid;
    private Animator animator;

    private void Init()
    {
        playerRigid = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();
    }

    private void Start() => Init();

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A)) playerPosition -= 1;
        if (Input.GetKeyDown(KeyCode.D)) playerPosition += 1;

        playerPosition = Mathf.Clamp(playerPosition, -1, 1);

        if (Physics.Raycast(transform.position + Vector3.up * 1.5f, Vector3.down, out RaycastHit hit, 3f, layerMask)) animator.Play("Run");
        
        else animator.Play("Jump");
        
        OnDrawRay();
    }

    private void FixedUpdate() => transform.position = new Vector3(Mathf.Lerp(transform.position.x, playerPosition * 6, 0.1f), transform.position.y, transform.position.z);

    private void OnJump()
    {
        if (Physics.Raycast(transform.position + Vector3.up * 1.5f, Vector3.down, out RaycastHit hitInfo, 3f, layerMask))
        {
            playerRigid.velocity = Vector3.up * playerJumpSpeed;
        }
    }

    private void OnDrawRay() => Debug.DrawRay(transform.position + Vector3.up * 1.5f, Vector3.down * 3f, new Color(0, 1, 0));
}
